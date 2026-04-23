pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool available: false
    property string active: ""
    property var profiles: []

    function set(profile) {
        if (!available) return
        setProc.command = ["powerprofilesctl", "set", profile]
        setProc.running = true
        Qt.callLater(refresh)
    }

    function cycle() {
        if (!available || profiles.length === 0) return
        var i = profiles.indexOf(active)
        var next = profiles[(i + 1) % profiles.length]
        set(next)
    }

    function refresh() {
        if (!available) return
        getProc.running = true
    }

    Process {
        id: whichProc
        command: ["sh", "-c", "command -v powerprofilesctl >/dev/null && powerprofilesctl list 2>/dev/null | awk '/^[* ] ?[a-z-]+:/ {gsub(/[*: ]/, \"\"); print}'"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                var lines = this.text.trim().split("\n").filter(function(s) { return s.length > 0 })
                root.profiles = lines
                root.available = lines.length > 0
                if (root.available) root.refresh()
            }
        }
    }

    Process {
        id: getProc
        command: ["powerprofilesctl", "get"]
        stdout: StdioCollector {
            onStreamFinished: root.active = this.text.trim()
        }
    }

    Process { id: setProc }

    Timer {
        interval: 5000
        running: root.available
        repeat: true
        onTriggered: root.refresh()
    }
}
