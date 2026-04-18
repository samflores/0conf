import QtQuick
import QtQuick.Layouts
import "../theme"

RowLayout {
    id: root

    required property var screen
    required property var niri

    spacing: 6

    Repeater {
        model: root.niri.workspaces

        Rectangle {
            visible: root.screen && root.screen.name === model.output
            implicitWidth: model.isActive ? 18 : 8
            implicitHeight: 8
            radius: 4
            color: model.isActive ? Theme.fg : Theme.fgDim
            opacity: model.isActive ? 1.0 : 0.5

            Behavior on implicitWidth {
                NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
            }
            Behavior on color {
                ColorAnimation { duration: 150 }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: root.niri.focusWorkspaceById(model.id)
            }
        }
    }
}
