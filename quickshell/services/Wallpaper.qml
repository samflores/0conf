pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    readonly property string dir: Quickshell.env("HOME") + "/Pictures/Wallpapers"
    readonly property string current: dir + "/current"

    property var files: []

    function refresh() {
        scanProc.running = true
    }

    function pick(path) {
        if (!path) return
        linkProc.running = false
        linkProc.command = ["sh", "-c",
            "ln -sfn " + shellQuote(path) + " " + shellQuote(root.current) +
            " && awww img " + shellQuote(root.current)]
        linkProc.running = true
    }

    function shellQuote(s) {
        return "'" + String(s).replace(/'/g, "'\\''") + "'"
    }

    Process {
        id: scanProc
        running: true
        command: ["sh", "-c",
            "find " + root.shellQuote(root.dir) +
            " -maxdepth 1 -type f \\( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.webp' \\) | sort"]
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = this.text.trim().split("\n").filter(l => l.length > 0)
                root.files = lines
            }
        }
    }

    Process {
        id: linkProc
    }
}
