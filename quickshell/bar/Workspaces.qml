import QtQuick
import QtQuick.Layouts
import Quickshell

Rectangle {
    property var screen: null
    anchors.left: parent.left
    color: "#ff0000"
    height: 25

    Rectangle {
        id: workspaceLayout
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            right: parent.right
        }

        RowLayout {
            anchors {
                verticalCenter: parent.verticalCenter
            }
            spacing: 5

            Repeater {
                model: niri.workspaces

                Rectangle {
                    visible: screen.name === model.output
                    width: 12
                    height: 12
                    radius: 6
                    color: "#cdd6f4"
                    opacity: model.isActive ? 1.0 : 0.3

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: niri.focusWorkspaceById(model.id)
                    }
                }
            }
        }
    }
}
