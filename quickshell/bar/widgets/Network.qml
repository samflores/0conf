import QtQuick
import "../../theme"
import "../../services"
import "../../utils"

MouseArea {
    id: root

    signal requestControlCenter()

    implicitWidth: icon.implicitWidth
    implicitHeight: icon.implicitHeight
    cursorShape: Qt.PointingHandCursor

    onClicked: root.requestControlCenter()

    Text {
        id: icon
        text: {
            if (!Network.connected) return Icons.systemIcons.wifiOff
            if (Network.signal >= 75) return Icons.systemIcons.wifiHigh
            if (Network.signal >= 50) return Icons.systemIcons.wifiMid
            return Icons.systemIcons.wifiLow
        }
        color: Network.connected ? Theme.fg : Theme.fgDim
        font.family: Theme.fontFamily
        font.pixelSize: Theme.iconSize
    }
}
