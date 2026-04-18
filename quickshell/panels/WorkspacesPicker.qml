import QtQuick
import QtQuick.Layouts
import "../theme"
import "../services"

Panel {
    id: root

    name: "workspaces"
    side: "left"
    contentPadding: 12

    required property var niri

    ColumnLayout {
        spacing: 8

        Repeater {
            model: root.niri.workspaces

            ColumnLayout {
                required property var model
                required property int index
                visible: model.output === root.panelScreen?.name
                spacing: 4
                Layout.fillWidth: true

                readonly property var wsWindows: Windows.windows.filter(w =>
                    w.workspaceId === model.id
                )

                Text {
                    text: model.name && model.name.length > 0
                        ? model.name
                        : ("Workspace " + index)
                    color: model.isActive ? Theme.accent : Theme.fgDim
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize - 1
                    font.bold: model.isActive
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 4

                    Repeater {
                        model: parent.parent.wsWindows

                        MouseArea {
                            required property var modelData
                            readonly property var bucketWidths: [80, 120, 170, 240]

                            Layout.preferredWidth: bucketWidths[modelData.bucket] || 80
                            implicitHeight: cell.implicitHeight + 10
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true
                            onClicked: {
                                root.niri.focusWindow(modelData.id)
                                PanelState.close()
                            }

                            Rectangle {
                                anchors.fill: parent
                                radius: 6
                                color: modelData.isFocused ? Theme.accent
                                    : parent.containsMouse ? Theme.bgAlt
                                    : Theme.surface
                            }

                            ColumnLayout {
                                id: cell
                                anchors.fill: parent
                                anchors.leftMargin: 8
                                anchors.rightMargin: 8
                                anchors.verticalCenter: parent.verticalCenter
                                spacing: 0

                                Text {
                                    text: modelData.appId || "?"
                                    color: modelData.isFocused ? Theme.bg : Theme.fg
                                    font.family: Theme.fontFamily
                                    font.pixelSize: Theme.fontSize - 1
                                    font.bold: true
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }
                                Text {
                                    text: modelData.title
                                    color: modelData.isFocused ? Theme.bg : Theme.fgDim
                                    font.family: Theme.fontFamily
                                    font.pixelSize: Theme.fontSize - 2
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }
                            }
                        }
                    }

                    Text {
                        visible: parent.parent.wsWindows.length === 0
                        text: "(empty)"
                        color: Theme.fgDim
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSize - 2
                    }
                }
            }
        }
    }
}
