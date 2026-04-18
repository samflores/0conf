pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool available: false
    property bool powered: false
    property string connectedDevice: ""

    function toggle() {
        toggleProc.command = ["bluetoothctl", "power", powered ? "off" : "on"]
        toggleProc.running = true
        Qt.callLater(refresh)
    }

    function refresh() { showProc.running = true }

    Process {
        id: showProc
        command: ["bluetoothctl", "show"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                var out = this.text
                if (out.trim() === "") {
                    root.available = false
                    root.powered = false
                    return
                }
                root.available = true
                var m = out.match(/Powered:\s*(yes|no)/)
                root.powered = m ? (m[1] === "yes") : false
            }
        }
    }

    Process {
        id: devicesProc
        command: ["sh", "-c", "bluetoothctl devices Connected 2>/dev/null | head -1 | cut -d' ' -f3-"]
        stdout: StdioCollector {
            onStreamFinished: root.connectedDevice = this.text.trim()
        }
    }

    Process { id: toggleProc }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: {
            showProc.running = true
            devicesProc.running = true
        }
    }
}
