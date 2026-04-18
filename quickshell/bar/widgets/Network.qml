import QtQuick
import "../../theme"
import "../../panels"
import "../../services"
import "../../utils"

MouseArea {
    id: root

    required property var barScreen

    implicitWidth: icon.implicitWidth
    implicitHeight: icon.implicitHeight
    cursorShape: Qt.PointingHandCursor

    onClicked: PanelState.toggle("network", "right", root.barScreen)

    Text {
        id: icon
        text: {
            if (!Network.connected) return Icons.systemIcons.wifiOff
            if (Network.signal >= 75) return Icons.systemIcons.wifiHigh
            if (Network.signal >= 50) return Icons.systemIcons.wifiMid
            return Icons.systemIcons.wifiLow
        }
        color: {
            if (PanelState.openPanel === "network") return Theme.accent
            return Network.connected ? Theme.fg : Theme.fgDim
        }
        font.family: Theme.fontFamily
        font.pixelSize: Theme.iconSize
    }
}
