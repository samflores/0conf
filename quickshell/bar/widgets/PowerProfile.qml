import QtQuick
import "../../theme"
import "../../panels"
import "../../services"
import "../../utils"

MouseArea {
    id: root

    required property var barScreen

    visible: PowerProfile.available
    implicitWidth: icon.implicitWidth
    implicitHeight: icon.implicitHeight
    cursorShape: Qt.PointingHandCursor

    onClicked: PanelState.toggle("powerprofile", "right", root.barScreen)

    Text {
        id: icon
        text: {
            if (PowerProfile.active === "performance") return Icons.systemIcons.perfPerformance
            if (PowerProfile.active === "power-saver") return Icons.systemIcons.perfPowerSaver
            return Icons.systemIcons.perfBalanced
        }
        color: {
            if (PanelState.openPanel === "powerprofile") return Theme.accent
            if (PowerProfile.active === "performance") return Theme.ok
            if (PowerProfile.active === "power-saver") return Theme.fgDim
            return Theme.fg
        }
        font.family: Theme.fontFamily
        font.pixelSize: Theme.iconSize
    }
}
