pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    // Array of { id, title, appId, workspaceId, isFocused, tileWidth, bucket }
    // `bucket` is the index of the closest Niri preset-column-width
    // proportion (0..presets.length-1), derived from tileWidth / output
    // logical width.
    property var windows: []

    // Niri preset column widths (match ~/.config/niri/layout.kdl).
    readonly property var presets: [0.32, 0.48, 0.67, 1.00]

    // Output logical widths keyed by output name. Populated from niri
    // msg outputs.
    property var outputWidths: ({})

    function refresh() { listProc.running = true }

    function windowsForWorkspace(wsId) {
        return windows.filter(w => w.workspaceId === wsId)
    }

    function bucketForProportion(p) {
        var best = 0
        var bestDelta = Math.abs(p - presets[0])
        for (var i = 1; i < presets.length; i++) {
            var d = Math.abs(p - presets[i])
            if (d < bestDelta) {
                bestDelta = d
                best = i
            }
        }
        return best
    }

    // Workspace id → output name, populated from niri msg workspaces.
    property var workspaceOutputs: ({})

    Process {
        id: outputsProc
        command: ["niri", "msg", "--json", "outputs"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    var obj = JSON.parse(this.text)
                    var widths = {}
                    // `obj` is a map { outputName: outputInfo }.
                    for (var name in obj) {
                        var o = obj[name]
                        if (o.logical) widths[name] = o.logical.width
                    }
                    root.outputWidths = widths
                } catch (e) {}
            }
        }
    }

    Process {
        id: workspacesProc
        command: ["niri", "msg", "--json", "workspaces"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    var arr = JSON.parse(this.text)
                    var map = {}
                    for (var i = 0; i < arr.length; i++) {
                        map[arr[i].id] = arr[i].output
                    }
                    root.workspaceOutputs = map
                } catch (e) {}
            }
        }
    }

    Process {
        id: listProc
        command: ["niri", "msg", "--json", "windows"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    var arr = JSON.parse(this.text)
                    root.windows = arr.map(w => {
                        var tileWidth = w.layout && w.layout.tile_size ? w.layout.tile_size[0] : 0
                        var outputName = root.workspaceOutputs[w.workspace_id] || ""
                        var outputWidth = root.outputWidths[outputName] || 0
                        var proportion = outputWidth > 0 ? tileWidth / outputWidth : 0
                        var pos = w.layout && w.layout.pos_in_scrolling_layout
                        return {
                            id: w.id,
                            title: w.title || "",
                            appId: w.app_id || "",
                            workspaceId: w.workspace_id,
                            isFocused: !!w.is_focused,
                            tileWidth: tileWidth,
                            output: outputName,
                            column: pos ? pos[0] : 0,
                            row: pos ? pos[1] : 0,
                            bucket: root.bucketForProportion(proportion)
                        }
                    }).sort((a, b) =>
                        a.workspaceId !== b.workspaceId
                            ? a.workspaceId - b.workspaceId
                            : a.column !== b.column
                                ? a.column - b.column
                                : a.row - b.row
                    )
                } catch (e) {
                    root.windows = []
                }
            }
        }
    }

    Timer {
        interval: 1500
        running: true
        repeat: true
        onTriggered: {
            workspacesProc.running = true
            outputsProc.running = true
            listProc.running = true
        }
    }
}
