import QtQuick
import Quickshell
import "../../theme"
import "../../panels"
import "../../services"

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

    function eventSuffix() {
        var n = GoogleCalendar.nextEvent
        var m = GoogleCalendar.minutesToNext
        if (!n || m < 0 || m >= 60) return ""
        var title = String(n.title || "")
        if (title.length > 22) title = title.substring(0, 21) + "…"
        var when = m <= 0 ? "now" : ("in " + m + "m")
        return "  •  " + title + " " + when
    }

    Text {
        id: label
        text: Qt.formatDateTime(clock.date, "ddd, MMM d • HH:mm") + root.eventSuffix()
        color: PanelState.openPanel === "calendar" ? Theme.accent : Theme.fg
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize
    }
}
