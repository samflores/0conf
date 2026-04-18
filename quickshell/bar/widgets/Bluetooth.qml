import QtQuick
import "../../theme"
import "../../panels"
import "../../services"
import "../../utils"

MouseArea {
    id: root

    required property var barScreen

    visible: Bluetooth.available
    implicitWidth: icon.implicitWidth
    implicitHeight: icon.implicitHeight
    cursorShape: Qt.PointingHandCursor

    onClicked: PanelState.toggle("bluetooth", "right", root.barScreen)

    Text {
        id: icon
        text: Bluetooth.powered ? Icons.systemIcons.bluetoothOn : Icons.systemIcons.bluetoothOff
        color: {
            if (PanelState.openPanel === "bluetooth") return Theme.accent
            return Bluetooth.powered ? Theme.fg : Theme.fgDim
        }
        font.family: Theme.fontFamily
        font.pixelSize: Theme.iconSize
    }
}
