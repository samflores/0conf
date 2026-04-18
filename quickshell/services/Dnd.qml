pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool enabled: false

    readonly property string stateDir: Quickshell.env("HOME") + "/.local/state/quickshell/"
    readonly property string statePath: stateDir + "dnd"

    function toggle() {
        enabled = !enabled
        writeProc.command = ["sh", "-c", "mkdir -p '" + stateDir + "' && echo " + (enabled ? "on" : "off") + " > '" + statePath + "'"]
        writeProc.running = true
    }

    Process {
        id: readProc
        command: ["sh", "-c", "cat '" + root.statePath + "' 2>/dev/null || echo off"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: root.enabled = (this.text.trim() === "on")
        }
    }

    Process { id: writeProc }
}
