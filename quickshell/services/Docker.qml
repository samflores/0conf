pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool available: false
    property var containers: []

    function refresh() {
        psProc.running = true
    }

    function stopContainer(id) {
        stopContainerProc.command = ["docker", "stop", id]
        stopContainerProc.running = true
    }

    Process {
        id: psProc
        // Listing containers also doubles as a daemon-up probe: docker ps
        // exits non-zero when the daemon is down.
        command: ["docker", "ps", "--format", "{{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}"]
        stdout: StdioCollector {
            onStreamFinished: {
                var lines = this.text.split("\n")
                var list = []
                for (var i = 0; i < lines.length; i++) {
                    var line = lines[i]
                    if (line === "") continue
                    var parts = line.split("\t")
                    if (parts.length < 4) continue
                    list.push({
                        id: parts[0],
                        name: parts[1],
                        image: parts[2],
                        status: parts[3]
                    })
                }
                root.containers = list
            }
        }
        onExited: function(code) {
            root.available = (code === 0)
            if (code !== 0) root.containers = []
        }
    }

    Process {
        id: stopContainerProc
        onRunningChanged: { if (!running) root.refresh() }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.refresh()
    }
}
