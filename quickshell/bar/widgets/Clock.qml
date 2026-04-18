import QtQuick
import Quickshell
import "../../theme"

Text {
    id: root

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    text: Qt.formatDateTime(clock.date, "ddd, MMM d • HH:mm")
    color: Theme.fg
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontSize
}
