pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool available: false
    property int percent: 0

    function refresh() { readProc.running = true }

    function set(p) {
        if (!available) return
        var clamped = Math.max(1, Math.min(100, p))
        setProc.command = ["brightnessctl", "--class=backlight", "set", clamped + "%"]
        setProc.running = true
        Qt.callLater(refresh)
    }

    Process {
        id: readProc
        command: ["sh", "-c", "brightnessctl --class=backlight -m 2>/dev/null | cut -d, -f4 | tr -d '%'"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                var v = this.text.trim()
                if (v === "") {
                    root.available = false
                    root.percent = 0
                } else {
                    root.available = true
                    root.percent = parseInt(v) || 0
                }
            }
        }
    }

    Process { id: setProc }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: readProc.running = true
    }
}
