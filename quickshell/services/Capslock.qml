pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool capsOn: false

    function refresh() { readProc.running = true }

    Process {
        id: readProc
        command: ["sh", "-c", "cat /sys/class/leds/*capslock/brightness 2>/dev/null"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                root.capsOn = this.text.trim() === "1"
            }
        }
    }

    Timer {
        interval: 500
        running: true
        repeat: true
        onTriggered: readProc.running = true
    }
}
