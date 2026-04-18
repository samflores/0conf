pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property int percent: 0

    function refresh() { readProc.running = true }

    function set(p) {
        var clamped = Math.max(1, Math.min(100, p))
        setProc.command = ["brightnessctl", "set", clamped + "%"]
        setProc.running = true
        Qt.callLater(refresh)
    }

    Process {
        id: readProc
        command: ["sh", "-c", "brightnessctl -m | cut -d, -f4 | tr -d '%'"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: root.percent = parseInt(this.text.trim()) || 0
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
