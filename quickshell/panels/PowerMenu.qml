import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "../theme"
import "../utils"

Panel {
    id: root

    name: "power"
    side: "right"

    Process { id: action }

    function run(cmd) {
        action.command = cmd
        action.running = true
        PanelState.close()
    }

    ColumnLayout {
        id: menu
        spacing: 0

        component Action: MouseArea {
            id: act
            property string label
            property string glyph
            property var command

            Layout.fillWidth: true
            implicitWidth: row.implicitWidth + 24
            implicitHeight: row.implicitHeight + 12
            cursorShape: Qt.PointingHandCursor

            onClicked: root.run(command)

            Rectangle {
                anchors.fill: parent
                color: act.containsMouse ? Theme.bgAlt : "transparent"
                radius: 6
            }
            hoverEnabled: true

            RowLayout {
                id: row
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                spacing: 10

                Text {
                    text: act.glyph
                    color: Theme.fg
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.iconSize
                }
                Text {
                    text: act.label
                    color: Theme.fg
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                    Layout.fillWidth: true
                }
            }
        }

        Action {
            label: "Lock"
            glyph: Icons.systemIcons.lock
            command: ["loginctl", "lock-session"]
        }
        Action {
            label: "Suspend"
            glyph: Icons.systemIcons.suspend
            command: ["loginctl", "suspend"]
        }
        Action {
            label: "Log out"
            glyph: Icons.systemIcons.logout
            command: ["niri", "msg", "action", "quit"]
        }
        Action {
            label: "Reboot"
            glyph: Icons.systemIcons.reboot
            command: ["loginctl", "reboot"]
        }
        Action {
            label: "Shut down"
            glyph: Icons.systemIcons.shutdown
            command: ["loginctl", "poweroff"]
        }
    }
}
