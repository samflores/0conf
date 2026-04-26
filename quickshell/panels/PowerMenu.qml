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

    // Confirmation state. While pendingLabel is non-empty the menu shows
    // a confirm prompt with a 5s countdown that defaults to running the
    // command.
    property string pendingLabel: ""
    property var pendingCommand: null
    property int countdown: 0

    function run(cmd) {
        action.command = cmd
        action.running = true
        cancelConfirm()
        PanelState.close()
    }

    function confirm(label, cmd) {
        root.pendingLabel = label
        root.pendingCommand = cmd
        root.countdown = 5
        countdownTimer.restart()
    }

    function cancelConfirm() {
        countdownTimer.stop()
        root.pendingLabel = ""
        root.pendingCommand = null
        root.countdown = 0
    }

    onOpenChanged: if (!open) cancelConfirm()

    Timer {
        id: countdownTimer
        interval: 1000
        repeat: true
        onTriggered: {
            root.countdown -= 1
            if (root.countdown <= 0) {
                root.run(root.pendingCommand)
            }
        }
    }

    component Action: MouseArea {
        id: act
        property string label
        property string glyph
        property var command
        property bool needsConfirm: false
        signal triggered()

        Layout.fillWidth: true
        implicitWidth: row.implicitWidth + 24
        implicitHeight: row.implicitHeight + 12
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true

        onClicked: act.triggered()

        Rectangle {
            anchors.fill: parent
            color: act.containsMouse ? Theme.bgAlt : "transparent"
            radius: 6
        }

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

    // Action list — visible when no confirmation is pending.
    ColumnLayout {
        id: menu
        spacing: 0
        visible: root.pendingLabel === ""

        Action {
            label: "Lock"
            glyph: Icons.systemIcons.lock
            command: ["loginctl", "lock-session"]
            onTriggered: root.run(command)
        }
        Action {
            label: "Suspend"
            glyph: Icons.systemIcons.suspend
            command: ["loginctl", "suspend"]
            onTriggered: root.run(command)
        }
        Action {
            label: "Log out"
            glyph: Icons.systemIcons.logout
            command: ["niri", "msg", "action", "quit"]
            onTriggered: root.run(command)
        }
        Action {
            label: "Reboot"
            glyph: Icons.systemIcons.reboot
            command: ["loginctl", "reboot"]
            onTriggered: root.confirm(label, command)
        }
        Action {
            label: "Shut down"
            glyph: Icons.systemIcons.shutdown
            command: ["loginctl", "poweroff"]
            onTriggered: root.confirm(label, command)
        }
    }

    // Confirmation prompt — visible while pendingLabel is set.
    ColumnLayout {
        id: confirmView
        visible: root.pendingLabel !== ""
        spacing: 10

        Text {
            text: root.pendingLabel + "?"
            color: Theme.fg
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize + 1
            font.bold: true
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            text: "Continuing in " + root.countdown + "s..."
            color: Theme.fgDim
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
            Layout.alignment: Qt.AlignHCenter
        }

        RowLayout {
            spacing: 8
            Layout.alignment: Qt.AlignHCenter

            MouseArea {
                id: yesBtn
                implicitWidth: yesText.implicitWidth + 24
                implicitHeight: yesText.implicitHeight + 12
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onClicked: root.run(root.pendingCommand)

                Rectangle {
                    anchors.fill: parent
                    radius: 6
                    color: yesBtn.containsMouse ? Theme.accent : Theme.surface
                    border.color: Theme.accent
                    border.width: 1
                }
                Text {
                    id: yesText
                    anchors.centerIn: parent
                    text: "Yes"
                    color: yesBtn.containsMouse ? Theme.bg : Theme.fg
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                    font.bold: true
                }
            }

            MouseArea {
                id: noBtn
                implicitWidth: noText.implicitWidth + 24
                implicitHeight: noText.implicitHeight + 12
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onClicked: root.cancelConfirm()

                Rectangle {
                    anchors.fill: parent
                    radius: 6
                    color: noBtn.containsMouse ? Theme.bgAlt : "transparent"
                    border.color: Theme.fgDim
                    border.width: 1
                }
                Text {
                    id: noText
                    anchors.centerIn: parent
                    text: "No"
                    color: Theme.fg
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                }
            }
        }
    }
}
