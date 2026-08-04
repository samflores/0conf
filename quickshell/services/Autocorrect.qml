pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool on: false
    property bool available: false

    function refresh() { readProc.running = true }

    Process {
        id: readProc
        command: ["/home/samflores/Code/0conf/quickshell/bin/qmk-autocorrect-state"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                var v = this.text.trim()
                root.available = v === "0" || v === "1"
                root.on = v === "1"
            }
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: readProc.running = true
    }
}
