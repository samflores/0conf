import QtQuick
import QtQuick.Layouts
import "../../theme"
import "../../panels"
import "../../services"
import "../../utils"

MouseArea {
    id: root

    required property var barScreen

    visible: Battery.present
    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight
    cursorShape: Qt.PointingHandCursor

    onClicked: PanelState.toggle("battery", "right", root.barScreen)

    RowLayout {
        id: row
        spacing: 4

        Text {
            text: {
                if (Battery.charging) return Icons.systemIcons.batteryCharging
                var p = Battery.percent
                if (p >= 85) return Icons.systemIcons.batteryFull
                if (p >= 60) return Icons.systemIcons.batteryThreeQ
                if (p >= 35) return Icons.systemIcons.batteryHalf
                if (p >= 15) return Icons.systemIcons.batteryQuarter
                return Icons.systemIcons.batteryEmpty
            }
            color: {
                if (PanelState.openPanel === "battery") return Theme.accent
                if (!Battery.charging && Battery.percent <= 15) return Theme.err
                if (Battery.charging) return Theme.ok
                return Theme.fg
            }
            font.family: Theme.fontFamily
            font.pixelSize: Theme.iconSize
        }

        Text {
            text: Battery.percent + "%"
            color: Theme.fg
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
        }
    }
}
