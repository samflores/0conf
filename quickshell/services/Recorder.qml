pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool recording: false
    property string lastFile: ""

    readonly property string outDir: Quickshell.env("HOME") + "/Media/Screen Recordings"

    function start() {
        if (recording) return
        startProc.command = ["sh", "-c",
            "mkdir -p \"" + root.outDir + "\" && " +
            "out=\"" + root.outDir + "/$(date +%Y-%m-%d_%H-%M-%S).mp4\" && " +
            "geom=\"$(slurp -d -F monospace)\" && " +
            "[ -n \"$geom\" ] && exec wf-recorder -g \"$geom\" -f \"$out\""]
        startProc.running = true
    }

    function startOutput() {
        if (recording) return
        startProc.command = ["sh", "-c",
            "mkdir -p \"" + root.outDir + "\" && " +
            "out=\"" + root.outDir + "/$(date +%Y-%m-%d_%H-%M-%S).mp4\" && " +
            "name=\"$(niri msg --json focused-output | jq -r .name)\" && " +
            "exec wf-recorder -o \"$name\" -f \"$out\""]
        startProc.running = true
    }

    function stop() {
        // SIGINT lets wf-recorder finalize the file cleanly.
        stopProc.command = ["pkill", "-INT", "-x", "wf-recorder"]
        stopProc.running = true
    }

    function toggle() {
        if (recording) stop()
        else start()
    }

    Process { id: startProc }
    Process { id: stopProc }

    Process {
        id: probe
        command: ["pgrep", "-x", "wf-recorder"]
        running: true
        onExited: function(code) {
            root.recording = (code === 0)
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: probe.running = true
    }
}
