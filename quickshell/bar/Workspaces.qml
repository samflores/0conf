import QtQuick
import QtQuick.Layouts
import "../theme"
import "../panels"
import "../services"

RowLayout {
    id: root

    required property var screen
    required property var niri
    required property var barScreen

    spacing: 6

    Repeater {
        model: root.niri.workspaces

        // Each workspace: a small pill containing proportional dots for
        // each window in that workspace.
        Rectangle {
            id: wsPill

            required property var model

            readonly property var wsWindows: Windows.windows.filter(w =>
                w.workspaceId === model.id
            )

            visible: root.screen && root.screen.name === model.output

            implicitWidth: Math.max(minWidth, dotsRow.implicitWidth + 6)
            readonly property int minWidth: model.isActive ? 18 : 10
            implicitHeight: 14
            radius: 7
            color: model.isActive ? Theme.surface : Theme.bgAlt
            opacity: model.isActive ? 1.0 : 0.6

            Behavior on implicitWidth {
                NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
            }
            Behavior on color {
                ColorAnimation { duration: 150 }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: function(mouse) {
                    if (mouse.button === Qt.RightButton) {
                        PanelState.toggle("workspaces", "left", root.barScreen)
                    } else {
                        root.niri.focusWorkspaceById(model.id)
                    }
                }
            }

            RowLayout {
                id: dotsRow
                anchors.centerIn: parent
                spacing: 2

                Repeater {
                    model: wsPill.wsWindows

                    Rectangle {
                        required property var modelData
                        readonly property var bucketSizes: [5, 7, 10, 14]
                        implicitWidth: bucketSizes[modelData.bucket] || 5
                        implicitHeight: 6
                        radius: 3
                        color: modelData.isFocused ? Theme.accent : Theme.fgDim
                    }
                }
            }
        }
    }
}
