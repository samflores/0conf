pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    // OpenVPN (work). States: down | connecting | auth | up | error
    property string openvpnState: "down"
    property string openvpnError: ""
    property string openvpnUser: ""
    readonly property bool openvpnUp: openvpnState === "up"
    readonly property bool openvpnBusy: openvpnState === "connecting" || openvpnState === "auth"

    // WireGuard (personal)
    property bool wireguardUp: false
    property bool wireguardBusy: false

    readonly property bool anyUp: openvpnUp || wireguardUp

    readonly property string runtimeDir: Quickshell.env("XDG_RUNTIME_DIR") || ("/run/user/" + Quickshell.env("UID"))
    readonly property string socketPath: runtimeDir + "/qs-openvpn.sock"
    readonly property string configDir: Quickshell.env("HOME") + "/.config/0conf"
    readonly property string configPath: configDir + "/vpn.json"

    // Auth values cached for the current connect attempt. Cleared on
    // CONNECTED, stop, or error.
    property string _pendingPassword: ""
    property string _pendingOtp: ""
    property bool _otpConsumed: false
    // CRV1 state token captured from a Verification Failed line. When set,
    // the next plain >PASSWORD:Need 'Auth' prompt is the post-restart auth
    // round and the OTP must be sent wrapped in CRV1::<state>::<otp>.
    property string _crv1State: ""

    function refresh() {
        openvpnProbe.running = true
        wgStatusProc.running = true
    }

    function startOpenvpn(user, password, otp) {
        if (openvpnState !== "down" && openvpnState !== "error") return
        root.openvpnUser = user
        root._pendingPassword = password
        root._pendingOtp = otp
        root._otpConsumed = false
        root._crv1State = ""
        root.openvpnError = ""
        root.openvpnState = "connecting"
        saveConfig()
        openvpnProc.command = ["doas", "/home/samflores/Code/0conf/quickshell/bin/qs-openvpn-up",
                               Quickshell.env("USER"), "samflores", root.socketPath]
        openvpnProc.running = true
        openMgmtTimer.restart()
    }

    function stopOpenvpn() {
        if (mgmt.connected) mgmt.write("signal SIGTERM\n")
        downProc.command = ["doas", "/home/samflores/Code/0conf/quickshell/bin/qs-openvpn-down"]
        downProc.running = true
    }

    function startWireguard() {
        if (wireguardUp || wireguardBusy) return
        wireguardBusy = true
        wgUpProc.command = ["doas", "wg-quick", "up", "wg0"]
        wgUpProc.running = true
    }

    function stopWireguard() {
        if (!wireguardUp || wireguardBusy) return
        wireguardBusy = true
        wgDownProc.command = ["doas", "wg-quick", "down", "wg0"]
        wgDownProc.running = true
    }

    function shquote(s) {
        return "'" + String(s).replace(/'/g, "'\\''") + "'"
    }

    function saveConfig() {
        var json = JSON.stringify({ openvpnUser: root.openvpnUser })
        saveProc.command = ["sh", "-c",
            "mkdir -p '" + root.configDir + "' && printf %s " +
            shquote(json) + " > '" + root.configPath + "'"]
        saveProc.running = true
    }

    Component.onCompleted: loadProc.running = true
    Process {
        id: loadProc
        command: ["sh", "-c", "cat '" + root.configPath + "' 2>/dev/null"]
        stdout: StdioCollector {
            onStreamFinished: {
                var t = this.text.trim()
                if (t === "") return
                try {
                    var o = JSON.parse(t)
                    if (o.openvpnUser) root.openvpnUser = o.openvpnUser
                } catch (e) {}
            }
        }
    }
    Process { id: saveProc }

    // --- OpenVPN process & management socket --------------------------------

    Process {
        id: openvpnProc
        onExited: function(code) {
            cleanupSock.running = true
            if (root.openvpnState !== "down") {
                root.openvpnState = "down"
                root._pendingPassword = ""
                root._pendingOtp = ""
                root._otpConsumed = false
                root._crv1State = ""
            }
            mgmt.connected = false
            mgmt.path = ""
        }
    }

    Process { id: cleanupSock; command: ["rm", "-f", root.socketPath] }
    Process { id: downProc }

    Timer {
        id: openMgmtTimer
        interval: 250
        repeat: true
        property int tries: 0
        onTriggered: {
            tries += 1
            if (mgmt.connected || mgmt.path !== "") { stop(); tries = 0; return }
            sockExistsProbe.running = true
            if (tries > 40) {  // ~10s give-up
                stop()
                tries = 0
                root.openvpnError = "Could not connect to OpenVPN management socket"
                root.openvpnState = "error"
            }
        }
    }

    Process {
        id: sockExistsProbe
        command: ["test", "-S", root.socketPath]
        onExited: function(code) {
            if (code === 0 && !mgmt.connected && mgmt.path === "") {
                mgmt.path = root.socketPath
                mgmt.connected = true
            }
        }
    }

    // Probe whether openvpn is currently running (recover state after reload).
    Process {
        id: openvpnProbe
        command: ["pgrep", "-f", "/etc/openvpn/openvpn.conf"]
        running: true
        onExited: function(code) {
            if (code === 0 && root.openvpnState === "down") {
                attachProbe.running = true
            } else if (code !== 0 && root.openvpnState === "up") {
                root.openvpnState = "down"
            }
        }
    }
    Process {
        id: attachProbe
        command: ["test", "-S", root.socketPath]
        onExited: function(code) {
            if (code === 0) {
                openMgmtTimer.restart()
                root.openvpnState = "auth"
            } else {
                root.openvpnState = "up"
            }
        }
    }

    Socket {
        id: mgmt
        path: ""

        parser: SplitParser {
            splitMarker: "\n"
            onRead: function(line) {
                root._handleMgmtLine(line)
            }
        }

        onConnectionStateChanged: {
            if (connected) {
                write("state on\n")
                write("hold release\n")
                if (root.openvpnState === "connecting") root.openvpnState = "auth"
            } else if (mgmt.path !== "") {
                mgmt.path = ""
            }
        }
    }

    function _handleMgmtLine(line) {
        line = line.replace(/\r$/, "")
        if (line === "") return

        // openvpn re-enters hold after auth-failure restarts; auto-release.
        if (line.indexOf(">HOLD:Waiting for hold release") === 0) {
            mgmt.write("hold release\n")
            return
        }

        // Static-challenge prompt: server sends the challenge text along with
        // the username/password request, response combines pass + OTP into
        // SCRV1.
        var sc = line.match(/^>PASSWORD:Need 'Auth' username\/password\s+SC:1,(.*)$/)
        if (sc) {
            if (root._pendingOtp === "") {
                root.openvpnError = "MFA required but no code provided"
                root.openvpnState = "error"
                stopOpenvpn()
                return
            }
            var b64pass = Qt.btoa(root._pendingPassword)
            var b64otp = Qt.btoa(root._pendingOtp)
            mgmt.write('username "Auth" "' + root.openvpnUser.replace(/"/g, '\\"') + '"\n')
            mgmt.write('password "Auth" "SCRV1:' + b64pass + ':' + b64otp + '"\n')
            root._otpConsumed = true
            root.openvpnState = "auth"
            return
        }

        // Plain prompt: first time send static password; if a CRV1 challenge
        // was captured, this prompt is the post-restart round and we answer
        // it with CRV1::<state>::<otp>.
        var m = line.match(/^>PASSWORD:Need 'Auth' username\/password$/)
        if (m) {
            var user = root.openvpnUser.replace(/"/g, '\\"')
            if (root._crv1State !== "") {
                if (root._otpConsumed || root._pendingOtp === "") {
                    root.openvpnError = "MFA rejected"
                    root.openvpnState = "error"
                    stopOpenvpn()
                    return
                }
                // Per management-notes.txt: CRV1::<state_id>::<response_text>
                // (note: TWO colons after state_id, not one)
                mgmt.write('username "Auth" "' + user + '"\n')
                mgmt.write('password "Auth" "CRV1::' + root._crv1State + '::' + root._pendingOtp.replace(/"/g, '\\"') + '"\n')
                root._otpConsumed = true
                root._crv1State = ""
            } else {
                mgmt.write('username "Auth" "' + user + '"\n')
                mgmt.write('password "Auth" "' + root._pendingPassword.replace(/"/g, '\\"') + '"\n')
            }
            root.openvpnState = "auth"
            return
        }

        // Dynamic challenge: server returned a CRV1 blob via Verification
        // Failed. Capture the state token; the response is sent on the NEXT
        // plain >PASSWORD:Need prompt (after openvpn auth-retry restarts).
        // Format: >PASSWORD:Verification Failed: 'Auth' ['CRV1:<flags>:<state>:<b64user>:<prompt>']
        // Note: the <prompt> may itself contain colons.
        var crv = line.match(/^>PASSWORD:Verification Failed: 'Auth' \['CRV1:[^:]*:([^:]+):[^:]*:.*'\]\s*$/)
        if (crv) {
            if (root._otpConsumed || root._pendingOtp === "") {
                root.openvpnError = root._otpConsumed
                                  ? "MFA rejected"
                                  : "MFA required but no code provided"
                root.openvpnState = "error"
                stopOpenvpn()
                return
            }
            root._crv1State = crv[1]
            return
        }

        // Plain Verification Failed without CRV1 — real failure (bad password
        // or Duo lockout). Stop trying.
        if (line.indexOf(">PASSWORD:Verification Failed") === 0) {
            root.openvpnError = "Authentication failed"
            root.openvpnState = "error"
            stopOpenvpn()
            return
        }

        // State updates: >STATE:<ts>,<state-name>,<desc>,...
        if (line.indexOf(">STATE:") === 0) {
            var parts = line.substring(7).split(",")
            var st = parts[1]
            if (st === "CONNECTED") {
                root.openvpnState = "up"
                root._pendingPassword = ""
                root._pendingOtp = ""
            } else if (st === "EXITING" || st === "RECONNECTING") {
                if (root.openvpnState === "up") root.openvpnState = "down"
            } else if (st === "WAIT" || st === "AUTH" || st === "GET_CONFIG" ||
                       st === "ASSIGN_IP" || st === "ADD_ROUTES" || st === "RESOLVE" ||
                       st === "TCP_CONNECT") {
                root.openvpnState = "auth"
            }
            return
        }
    }

    // --- WireGuard ----------------------------------------------------------

    Process {
        id: wgStatusProc
        command: ["sh", "-c", "test -d /sys/class/net/wg0 && echo up || echo down"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: root.wireguardUp = (this.text.trim() === "up")
        }
    }

    Process {
        id: wgUpProc
        onExited: function(code) {
            root.wireguardBusy = false
            root.refresh()
        }
    }
    Process {
        id: wgDownProc
        onExited: function(code) {
            root.wireguardBusy = false
            root.refresh()
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: root.refresh()
    }
}
