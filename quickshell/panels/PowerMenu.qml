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
    // a tray-style submenu with Yes/No entries and a 5s countdown that
    // defaults to running the command.
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
        PanelState.sticky = true
        countdownTimer.restart()
    }

    function cancelConfirm() {
        countdownTimer.stop()
        root.pendingLabel = ""
        root.pendingCommand = null
        root.countdown = 0
        PanelState.sticky = false
    }

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

    // Pin the panel open while a confirm is pending — re-assert if any
    // path tries to close or switch panels.
    Connections {
        target: PanelState
        function onOpenPanelChanged() {
            if (root.pendingLabel === "") return
            if (PanelState.openPanel !== "power" || PanelState.openScreen !== root.panelScreen) {
                Qt.callLater(function() {
                    if (root.pendingLabel === "") return
                    PanelState.openPanel = "power"
                    PanelState.openSide = "right"
                    PanelState.openScreen = root.panelScreen
                    PanelState.sticky = true
                })
            }
        }
    }

    component Row: MouseArea {
        id: r
        property string label
        property string glyph
        signal triggered()

        Layout.fillWidth: true
        implicitWidth: rowLayout.implicitWidth + 24
        implicitHeight: rowLayout.implicitHeight + 12
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true

        onClicked: r.triggered()

        Rectangle {
            anchors.fill: parent
            color: r.containsMouse ? Theme.bgAlt : "transparent"
            radius: 6
        }

        RowLayout {
            id: rowLayout
            anchors.fill: parent
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            spacing: 10

            Text {
                text: r.glyph
                color: Theme.fg
                font.family: Theme.fontFamily
                font.pixelSize: Theme.iconSize
            }
            Text {
                text: r.label
                color: Theme.fg
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize
                Layout.fillWidth: true
            }
        }
    }

    ColumnLayout {
        id: contentCol
        spacing: 2

        // Header — only shown in confirm view (mirrors TrayPanel's
        // breadcrumb). Click returns to the action list.
        MouseArea {
            visible: root.pendingLabel !== ""
            Layout.fillWidth: true
            implicitWidth: headerRow.implicitWidth + 16
            implicitHeight: 26
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            onClicked: root.cancelConfirm()

            Rectangle {
                anchors.fill: parent
                radius: 6
                color: parent.containsMouse ? Theme.bgAlt : "transparent"
            }

            RowLayout {
                id: headerRow
                anchors.fill: parent
                anchors.leftMargin: 6
                anchors.rightMargin: 8
                spacing: 8

                Text {
                    text: ""  // fa-chevron-left
                    color: Theme.fgDim
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                }
                Text {
                    text: root.pendingLabel
                    color: Theme.fg
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                    font.bold: true
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                }
            }
        }

        // Action list — visible when no confirmation is pending.
        ColumnLayout {
            id: menu
            spacing: 0
            visible: root.pendingLabel === ""

            Row {
                label: "Lock"
                glyph: Icons.systemIcons.lock
                onTriggered: root.run(["loginctl", "lock-session"])
            }
            Row {
                label: "Suspend"
                glyph: Icons.systemIcons.suspend
                onTriggered: root.run(["loginctl", "suspend"])
            }
            Row {
                label: "Log out"
                glyph: Icons.systemIcons.logout
                onTriggered: root.run(["niri", "msg", "action", "quit"])
            }
            Row {
                label: "Reboot"
                glyph: Icons.systemIcons.reboot
                onTriggered: root.confirm(label, ["loginctl", "reboot"])
            }
            Row {
                label: "Shut down"
                glyph: Icons.systemIcons.shutdown
                onTriggered: root.confirm(label, ["loginctl", "poweroff"])
            }
        }

        // Confirmation submenu — visible while pendingLabel is set.
        ColumnLayout {
            id: confirmView
            visible: root.pendingLabel !== ""
            spacing: 0

            Row {
                label: "Yes (" + root.countdown + "s)"
                glyph: ""  // fa-check
                onTriggered: root.run(root.pendingCommand)
            }
            Row {
                label: "No"
                glyph: ""  // fa-times
                onTriggered: {
                    root.cancelConfirm()
                    PanelState.close()
                }
            }
        }
    }
}
