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
        proc.command = ["/home/samflores/Code/0conf/niri/bin/qs-record", "region"]
        proc.running = true
    }

    function startOutput() {
        if (recording) return
        proc.command = ["/home/samflores/Code/0conf/niri/bin/qs-record", "output"]
        proc.running = true
    }

    function stop() {
        // The script toggles, so calling it while recording stops cleanly.
        proc.command = ["/home/samflores/Code/0conf/niri/bin/qs-record", "region"]
        proc.running = true
    }

    function toggle() {
        if (recording) stop()
        else start()
    }

    Process { id: proc }

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
