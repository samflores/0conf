import QtQuick
import QtQuick.Layouts
import "../../theme"
import "../../panels"
import "../../services"
import "../../utils"

MouseArea {
    id: root

    required property var barScreen

    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight
    cursorShape: Qt.PointingHandCursor
    hoverEnabled: true

    onClicked: PanelState.toggle("network", "right", root.barScreen)

    RowLayout {
        id: row
        spacing: 4

        Text {
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

        Text {
            text: Network.connected ? (Network.signal + "%") : (Network.networks.length + " available")
            visible: root.containsMouse
            color: Theme.fg
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
        }
    }
}
