pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string device: ""
    property bool connected: false
    property string ssid: ""
    property int signal: 0  // 0-100

    function refresh() {
        if (device === "") {
            deviceProc.running = true
        } else {
            statusProc.running = true
        }
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
                if (root.device !== "") statusProc.running = true
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

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: root.refresh()
    }
}
