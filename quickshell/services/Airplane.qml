pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool enabled: false

    function toggle() {
        setProc.command = ["rfkill", enabled ? "unblock" : "block", "all"]
        setProc.running = true
        Qt.callLater(refresh)
    }

    function refresh() {
        checkProc.running = true
    }

    Process {
        id: checkProc
        command: ["sh", "-c", "rfkill --output SOFT --noheadings | grep -cv unblocked || true"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                var n = parseInt(this.text.trim())
                root.enabled = !isNaN(n) && n > 0
            }
        }
    }

    Process { id: setProc }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: root.refresh()
    }
}
