import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Notifications
import Quickshell.Widgets
import "../theme"
import "../services"

Rectangle {
    id: popup

    required property var notif
    required property int popupIndex

    readonly property bool focused: Notifications.focusIndex === popupIndex
    readonly property bool isCritical: notif && notif.urgency === NotificationUrgency.Critical
    readonly property bool isLow: notif && notif.urgency === NotificationUrgency.Low

    implicitWidth: 360
    implicitHeight: content.implicitHeight + 20

    radius: Theme.pillRadius
    color: Theme.bg
    border.width: popup.focused ? 2 : 0
    border.color: popup.isCritical ? Theme.err : Theme.accent

    Timer {
        id: autoDismiss
        interval: popup.notif && popup.notif.expireTimeout > 0 ? popup.notif.expireTimeout : 5000
        running: popup.notif && !popup.focused && !popup.isCritical && popup.notif.expireTimeout !== 0
        repeat: false
        onTriggered: if (popup.notif) popup.notif.expire()
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: function(mouse) {
            if (mouse.button === Qt.RightButton) {
                if (popup.notif) popup.notif.dismiss()
            } else {
                Notifications.focusIndex = popup.popupIndex
            }
        }
    }

    readonly property var actionHint: ["n", "t", "e", "s", "i", "r", "o", "a"]

    readonly property string iconSource: {
        if (!popup.notif) return ""
        if (popup.notif.image && popup.notif.image.length > 0) return popup.notif.image
        if (popup.notif.appIcon && popup.notif.appIcon.length > 0) return "image://icon/" + popup.notif.appIcon
        if (popup.notif.desktopEntry && popup.notif.desktopEntry.length > 0) return "image://desktop/" + popup.notif.desktopEntry
        return ""
    }

    RowLayout {
        id: content
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        IconImage {
            visible: popup.iconSource.length > 0
            source: popup.iconSource
            implicitSize: 36
            Layout.alignment: Qt.AlignTop
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 6

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Text {
                    text: (popup.notif && popup.notif.appName) || "notification"
                    color: popup.isCritical ? Theme.err : (popup.isLow ? Theme.fgDim : Theme.accent)
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize - 2
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                }
                MouseArea {
                    implicitWidth: closeText.implicitWidth
                    implicitHeight: closeText.implicitHeight
                    cursorShape: Qt.PointingHandCursor
                    onClicked: if (popup.notif) popup.notif.dismiss()
                    Text {
                        id: closeText
                        text: ""
                        color: Theme.fgDim
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSize
                    }
                }
            }

            Text {
                visible: text.length > 0
                text: (popup.notif && popup.notif.summary) || ""
                color: Theme.fg
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize
                font.bold: true
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
            }

            Text {
                visible: text.length > 0
                text: (popup.notif && popup.notif.body) || ""
                color: Theme.fg
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                textFormat: Text.RichText
            }

            Flow {
                Layout.fillWidth: true
                spacing: 6
                visible: popup.notif && popup.notif.actions && popup.notif.actions.length > 0

                Repeater {
                    model: (popup.notif && popup.notif.actions) || []

                    Rectangle {
                        id: btn
                        required property var modelData
                        required property int index
                        implicitWidth: actionRow.implicitWidth + 14
                        implicitHeight: actionRow.implicitHeight + 8
                        radius: 6
                        color: btnArea.containsMouse ? Theme.surface : Theme.bgAlt

                        MouseArea {
                            id: btnArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: btn.modelData.invoke()
                        }

                        RowLayout {
                            id: actionRow
                            anchors.centerIn: parent
                            spacing: 6

                            Text {
                                text: (popup.focused && btn.index < popup.actionHint.length ? popup.actionHint[btn.index] + " " : "") + btn.modelData.text
                                color: Theme.fg
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontSize - 1
                            }
                        }
                    }
                }
            }
        }
    }
}
