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

    onClicked: PanelState.toggle("vpn", "right", root.barScreen)

    RowLayout {
        id: row
        spacing: 4

        Text {
            text: Vpn.anyUp ? Icons.systemIcons.vpnOn : Icons.systemIcons.vpnOff
            color: PanelState.openPanel === "vpn"
                   ? Theme.accent
                   : (Vpn.anyUp ? Theme.ok : Theme.fgDim)
            font.family: Theme.fontFamily
            font.pixelSize: Theme.iconSize
        }

        Text {
            visible: root.containsMouse
            text: {
                var bits = []
                if (Vpn.openvpnUp) bits.push("work")
                if (Vpn.wireguardUp) bits.push("personal")
                if (Vpn.openvpnBusy) bits.push("work…")
                if (Vpn.wireguardBusy) bits.push("personal…")
                return bits.length === 0 ? "off" : bits.join(", ")
            }
            color: Theme.fg
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
        }
    }
}
