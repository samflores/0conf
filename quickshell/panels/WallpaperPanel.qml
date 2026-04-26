import QtQuick
import QtQuick.Layouts
import "../theme"
import "../services"
import "../utils"

Panel {
    id: root

    name: "wallpaper"
    side: "right"
    contentPadding: 12

    readonly property int thumbW: 160
    readonly property int thumbH: 90
    readonly property int columns: 4
    readonly property int gap: 8

    onOpenChanged: if (open) Wallpaper.refresh()

    function basename(p) {
        const i = String(p).lastIndexOf("/")
        return i >= 0 ? p.substring(i + 1) : p
    }

    ColumnLayout {
        spacing: 10

        Text {
            text: "Wallpaper"
            color: Theme.fg
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize + 1
            font.bold: true
        }

        Grid {
            id: grid
            columns: root.columns
            spacing: root.gap

            Repeater {
                model: Wallpaper.files

                MouseArea {
                    id: cell
                    required property string modelData

                    width: root.thumbW
                    height: root.thumbH + label.implicitHeight + 6
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true

                    onClicked: {
                        Wallpaper.pick(modelData)
                        PanelState.close()
                    }

                    Rectangle {
                        anchors.fill: parent
                        radius: 6
                        color: cell.containsMouse ? Theme.bgAlt : "transparent"
                    }

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 4
                        spacing: 4

                        Rectangle {
                            Layout.preferredWidth: root.thumbW - 8
                            Layout.preferredHeight: root.thumbH
                            radius: 4
                            color: Theme.surface
                            clip: true
                            border.color: Theme.accent
                            border.width: cell.containsMouse ? 2 : 0

                            Image {
                                id: img
                                anchors.fill: parent
                                source: "file://" + cell.modelData
                                fillMode: Image.PreserveAspectCrop
                                asynchronous: true
                                cache: true
                                sourceSize.width: root.thumbW * 2
                                sourceSize.height: root.thumbH * 2
                                visible: status === Image.Ready
                            }
                            Text {
                                anchors.centerIn: parent
                                visible: img.status !== Image.Ready
                                text: "..."
                                color: Theme.fgDim
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontSize
                            }
                        }

                        Text {
                            id: label
                            Layout.preferredWidth: root.thumbW - 8
                            text: root.basename(cell.modelData)
                            color: Theme.fg
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSize - 2
                            elide: Text.ElideRight
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }
                }
            }
        }

        Text {
            visible: Wallpaper.files.length === 0
            text: "No images in " + Wallpaper.dir
            color: Theme.fgDim
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
        }
    }
}
