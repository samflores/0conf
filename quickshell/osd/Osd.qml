import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import "../theme"
import "../services"
import "../utils"

PanelWindow {
    id: root

    required property var modelData
    screen: modelData

    // Only render on the currently focused Niri output. Each shell
    // instance owns its own `focusedOutput` string that tracks niri's
    // focused-output name via niri msg.
    property string focusedOutput: ""

    readonly property bool isFocusedScreen: focusedOutput === screen?.name

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.exclusionMode: ExclusionMode.Ignore

    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }
    color: "transparent"
    mask: Region {}  // fully click-through

    Process {
        id: focusedOutputProc
        command: ["sh", "-c", "niri msg --json focused-output"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    var obj = JSON.parse(this.text)
                    root.focusedOutput = obj.name || ""
                } catch (e) {}
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: focusedOutputProc.running = true
    }

    // Suppress OSDs during shell startup so initial property values
    // don't trigger a burst.
    property bool ready: false
    Timer { interval: 800; running: true; repeat: false; onTriggered: root.ready = true }

    // Single visual state; whichever signal fires last overwrites.
    property string iconGlyph: ""
    property int valuePercent: -1     // -1 = no progress bar
    property string label: ""         // used when valuePercent is -1
    property bool showing: false

    Timer {
        id: hideTimer
        interval: 1500
        onTriggered: root.showing = false
    }

    function trigger(icon, percent, text) {
        if (!ready || !isFocusedScreen) return
        iconGlyph = icon
        valuePercent = percent
        label = text || ""
        showing = true
        hideTimer.restart()
    }

    // Subscriptions.
    Connections {
        target: Audio
        function onVolumeChanged() {
            var glyph = Audio.muted ? Icons.systemIcons.volumeMute
                      : Audio.volume <= 33 ? Icons.systemIcons.volumeLow
                      : Audio.volume <= 66 ? Icons.systemIcons.volumeMid
                      : Icons.systemIcons.volume
            root.trigger(glyph, Audio.volume, "")
        }
        function onMutedChanged() {
            root.trigger(Audio.muted ? Icons.systemIcons.volumeMute : Icons.systemIcons.volume,
                         -1, Audio.muted ? "Muted" : "Unmuted")
        }
        function onMicMutedChanged() {
            root.trigger(Audio.micMuted ? Icons.systemIcons.micMute : Icons.systemIcons.mic,
                         -1, Audio.micMuted ? "Mic muted" : "Mic unmuted")
        }
    }

    Rectangle {
        id: body
        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height - height - 60
        implicitWidth: 180
        implicitHeight: 56
        radius: 10
        color: Theme.bg
        border.width: 1
        border.color: Theme.border

        opacity: root.showing ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 150 } }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 14
            anchors.rightMargin: 14
            spacing: 10

            Text {
                text: root.iconGlyph
                color: Theme.fg
                font.family: Theme.fontFamily
                font.pixelSize: Theme.iconSize + 6
            }

            // Progress bar when valuePercent >= 0
            Rectangle {
                visible: root.valuePercent >= 0
                Layout.fillWidth: true
                Layout.preferredHeight: 4
                radius: 2
                color: Theme.surface

                Rectangle {
                    width: parent.width * Math.max(0, Math.min(100, root.valuePercent)) / 100
                    height: parent.height
                    radius: 2
                    color: Theme.accent
                }
            }

            // Label when no progress bar.
            Text {
                visible: root.valuePercent < 0
                text: root.label
                color: Theme.fg
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize
                Layout.fillWidth: true
            }
        }
    }
}
