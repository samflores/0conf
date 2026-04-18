import QtQuick
import "../../theme"
import "../../services"
import "../../utils"

MouseArea {
    id: root

    signal requestControlCenter()

    visible: Bluetooth.available
    implicitWidth: icon.implicitWidth
    implicitHeight: icon.implicitHeight
    cursorShape: Qt.PointingHandCursor

    onClicked: root.requestControlCenter()

    Text {
        id: icon
        text: Bluetooth.powered ? Icons.systemIcons.bluetoothOn : Icons.systemIcons.bluetoothOff
        color: Bluetooth.powered ? Theme.fg : Theme.fgDim
        font.family: Theme.fontFamily
        font.pixelSize: Theme.iconSize
    }
}
