pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool dark: true

    readonly property string stateDir: Quickshell.env("HOME") + "/.local/state/quickshell/"
    readonly property string statePath: stateDir + "theme"

    function toggle() {
        dark = !dark
        writeProc.command = ["sh", "-c", "mkdir -p '" + stateDir + "' && echo " + (dark ? "dark" : "light") + " > '" + statePath + "'"]
        writeProc.running = true
    }

    Process {
        id: readProc
        command: ["sh", "-c", "cat '" + root.statePath + "' 2>/dev/null || echo dark"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: root.dark = (this.text.trim() !== "light")
        }
    }

    Process {
        id: writeProc
    }
}
