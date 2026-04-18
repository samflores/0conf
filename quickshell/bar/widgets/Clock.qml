import QtQuick
import Quickshell
import "../../theme"
import "../../panels"

MouseArea {
    id: root

    required property var barScreen

    implicitWidth: label.implicitWidth
    implicitHeight: label.implicitHeight
    cursorShape: Qt.PointingHandCursor

    onClicked: PanelState.toggle("calendar", "center", root.barScreen)

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    Text {
        id: label
        text: Qt.formatDateTime(clock.date, "ddd, MMM d • HH:mm")
        color: PanelState.openPanel === "calendar" ? Theme.accent : Theme.fg
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize
    }
}
