import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
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

            Slider {
                id: slider
                Layout.fillWidth: true
                implicitWidth: 220
                from: 0
                to: 100
                value: Audio.micVolume
                onMoved: Audio.setMicVolume(value)

                background: Rectangle {
                    x: slider.leftPadding
                    y: slider.topPadding + slider.availableHeight / 2 - 2
                    width: slider.availableWidth
                    height: 4
                    radius: 2
                    color: Theme.surface
                    Rectangle {
                        width: slider.visualPosition * parent.width
                        height: parent.height
                        color: Theme.accent
                        radius: 2
                    }
                }
                handle: Rectangle {
                    x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
                    y: slider.topPadding + slider.availableHeight / 2 - height / 2
                    width: 12
                    height: 12
                    radius: 6
                    color: Theme.fg
                    border.color: Theme.accent
                    border.width: 1
                }
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
