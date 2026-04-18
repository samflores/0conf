pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string device: ""
    property bool connected: false
    property string ssid: ""
    property int signal: 0

    // Lists of network names (strings). Signal-sorted.
    property var networks: []      // currently visible (from get-networks)
    property var knownNetworks: [] // names in iwd's known-networks store

    property bool scanning: false

    function refresh() {
        if (device === "") {
            deviceProc.running = true
        } else {
            statusProc.running = true
        }
    }

    function scan() {
        if (device === "" || scanning) return
        scanning = true
        scanProc.command = ["iwctl", "station", device, "scan"]
        scanProc.running = true
    }

    function connectTo(ssid) {
        if (device === "") return
        connectProc.command = ["iwctl", "station", device, "connect", ssid]
        connectProc.running = true
    }

    function rssiToSignal(rssi) {
        if (rssi >= -50) return 100
        if (rssi >= -60) return 75
        if (rssi >= -70) return 50
        if (rssi >= -80) return 25
        return 0
    }

    Process {
        id: deviceProc
        command: ["sh", "-c", "iwctl device list | sed 's/\\x1b\\[[0-9;]*m//g' | awk '/station/ {print $1; exit}'"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                root.device = this.text.trim()
                if (root.device !== "") {
                    statusProc.running = true
                    knownProc.running = true
                    networksProc.running = true
                }
            }
        }
    }

    Process {
        id: statusProc
        command: ["sh", "-c", root.device === "" ? "true" : ("iwctl station " + root.device + " show | sed 's/\\x1b\\[[0-9;]*m//g'")]
        stdout: StdioCollector {
            onStreamFinished: {
                var out = this.text
                var lines = out.split("\n")
                var state = ""
                var network = ""
                var rssi = -100

                for (var i = 0; i < lines.length; i++) {
                    var line = lines[i]
                    var m

                    m = line.match(/State\s+(\S+)/)
                    if (m) state = m[1]

                    m = line.match(/Connected network\s+(.+?)\s*$/)
                    if (m) network = m[1].trim()

                    m = line.match(/^\s*RSSI\s+(-?\d+)/)
                    if (m) rssi = parseInt(m[1])
                }

                root.connected = (state === "connected")
                root.ssid = network
                root.signal = root.connected ? root.rssiToSignal(rssi) : 0
            }
        }
    }

    Process {
        id: networksProc
        command: ["sh", "-c", root.device === "" ? "true" : ("iwctl station " + root.device + " get-networks | sed 's/\\x1b\\[[0-9;]*m//g'")]
        stdout: StdioCollector {
            onStreamFinished: {
                var out = this.text
                var lines = out.split("\n")
                var names = []
                for (var i = 0; i < lines.length; i++) {
                    var line = lines[i]
                    // Skip headers and separators.
                    if (line.trim() === "" || line.indexOf("---") !== -1) continue
                    if (line.indexOf("Network name") !== -1 || line.indexOf("Available networks") !== -1) continue
                    // Format: optional ">" marker + name (possibly with spaces) + security + signal.
                    // Strip leading indicator "  >  " or "      ", then take the name up to 2+ spaces before security.
                    var m = line.match(/^\s*(?:>\s*)?(\S.*?)\s{2,}(?:open|psk|8021x|wep)\s/)
                    if (m) names.push(m[1].trim())
                }
                root.networks = names
            }
        }
    }

    Process {
        id: knownProc
        command: ["sh", "-c", "iwctl known-networks list | sed 's/\\x1b\\[[0-9;]*m//g'"]
        stdout: StdioCollector {
            onStreamFinished: {
                var out = this.text
                var lines = out.split("\n")
                var names = []
                for (var i = 0; i < lines.length; i++) {
                    var line = lines[i]
                    if (line.trim() === "" || line.indexOf("---") !== -1) continue
                    if (line.indexOf("Name") !== -1 || line.indexOf("Known Networks") !== -1) continue
                    var m = line.match(/^\s*(\S.*?)\s{2,}(?:open|psk|8021x|wep)\s/)
                    if (m) names.push(m[1].trim())
                }
                root.knownNetworks = names
            }
        }
    }

    Process {
        id: scanProc
        onRunningChanged: {
            if (!running) {
                // Scan finishes; refresh the network list shortly after.
                root.scanning = false
                refreshAfterScan.start()
            }
        }
    }

    Process {
        id: connectProc
        onRunningChanged: {
            if (!running) refreshAfterScan.start()
        }
    }

    Timer {
        id: refreshAfterScan
        interval: 1500
        onTriggered: {
            networksProc.running = true
            statusProc.running = true
            knownProc.running = true
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: root.refresh()
    }
}
