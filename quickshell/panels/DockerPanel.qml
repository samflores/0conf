import QtQuick
import QtQuick.Layouts
import "../theme"
import "../services"

Panel {
    id: root

    name: "docker"
    side: "right"
    contentPadding: 12

    ColumnLayout {
        spacing: 6

        Text {
            text: "Containers"
            color: Theme.fgDim
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize - 1
            visible: Docker.containers.length > 0
            Layout.minimumWidth: 220
        }

        Repeater {
            model: Docker.containers

            RowLayout {
                Layout.fillWidth: true
                spacing: 6

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 0

                    Text {
                        text: modelData.name
                        color: Theme.fg
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSize
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                    }
                    Text {
                        text: modelData.image + " · " + modelData.status
                        color: Theme.fgDim
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSize - 2
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                    }
                }

                MouseArea {
                    implicitWidth: stopGlyph.implicitWidth + 16
                    implicitHeight: stopGlyph.implicitHeight + 10
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onClicked: Docker.stopContainer(modelData.id)

                    Rectangle {
                        anchors.fill: parent
                        radius: 6
                        color: parent.containsMouse ? Theme.bgAlt : "transparent"
                    }

                    Text {
                        id: stopGlyph
                        anchors.centerIn: parent
                        text: ""  // nf-fa-stop
                        color: parent.containsMouse ? Theme.accent : Theme.fgDim
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.iconSize
                    }
                }
            }
        }

        Text {
            text: "No running containers"
            color: Theme.fgDim
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
            visible: Docker.containers.length === 0
            Layout.alignment: Qt.AlignHCenter
            topPadding: 4
            bottomPadding: 4
        }
    }
}
