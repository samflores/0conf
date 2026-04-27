import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire
import "../theme"
import "../services"
import "../utils"

Panel {
    id: root

    name: "mic"
    side: "right"
    contentPadding: 12

    readonly property var inputs: Pipewire.nodes.values.filter(n =>
        !n.isSink && !n.isStream && n.audio
    )

    ColumnLayout {
        spacing: 10

        // Slider + mute row
        RowLayout {
            spacing: 10
            Layout.fillWidth: true

            MouseArea {
                implicitWidth: icon.implicitWidth + 4
                implicitHeight: icon.implicitHeight + 4
                cursorShape: Qt.PointingHandCursor
                onClicked: Audio.toggleMicMute()
                Text {
                    id: icon
                    anchors.centerIn: parent
                    text: Audio.micMuted ? Icons.systemIcons.micMute : Icons.systemIcons.mic
                    color: Audio.micMuted ? Theme.fgDim : Theme.fg
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.iconSize + 2
                }
            }

            PanelSlider {
                Layout.fillWidth: true
                implicitWidth: 220
                from: 0
                to: 100
                value: Audio.micVolume
                onMoved: function(v) { Audio.setMicVolume(v) }
            }

            Text {
                text: Audio.micVolume + "%"
                color: Theme.fgDim
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize
                Layout.preferredWidth: 36
                horizontalAlignment: Text.AlignRight
            }
        }

        Text {
            text: "Input"
            color: Theme.fgDim
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize - 1
            topPadding: 4
        }

        Repeater {
            model: root.inputs

            MouseArea {
                Layout.fillWidth: true
                implicitWidth: deviceRow.implicitWidth + 16
                implicitHeight: deviceRow.implicitHeight + 8
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onClicked: Pipewire.preferredDefaultAudioSource = modelData

                Rectangle {
                    anchors.fill: parent
                    radius: 6
                    color: parent.containsMouse ? Theme.bgAlt : "transparent"
                }

                RowLayout {
                    id: deviceRow
                    anchors.fill: parent
                    anchors.leftMargin: 8
                    anchors.rightMargin: 8
                    spacing: 8

                    Text {
                        text: Audio.source === modelData ? "\uf00c" : ""
                        color: Theme.accent
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSize
                        Layout.preferredWidth: 14
                    }
                    Text {
                        text: modelData.description || modelData.name
                        color: Theme.fg
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSize
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                    }
                }
            }
        }
    }
}
