pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    readonly property string args: "-l -5.1 -L -42.7"

    property bool available: false
    property bool enabled: false

    function toggle() {
        if (!available) return
        if (enabled) {
            stopProc.running = true
        } else {
            startProc.running = true
        }
        Qt.callLater(refresh)
    }

    function refresh() {
        checkProc.running = true
    }

    Process {
        id: whichProc
        command: ["sh", "-c", "command -v wlsunset >/dev/null && echo yes || echo no"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                root.available = (this.text.trim() === "yes")
                if (root.available) root.refresh()
            }
        }
    }

    Process {
        id: checkProc
        command: ["sh", "-c", "pgrep -x wlsunset >/dev/null && echo on || echo off"]
        stdout: StdioCollector {
            onStreamFinished: root.enabled = (this.text.trim() === "on")
        }
    }

    Process {
        id: startProc
        command: ["sh", "-c", "setsid wlsunset " + root.args + " >/dev/null 2>&1 &"]
    }

    Process {
        id: stopProc
        command: ["pkill", "-x", "wlsunset"]
    }

    Timer {
        interval: 5000
        running: root.available
        repeat: true
        onTriggered: root.refresh()
    }
}
