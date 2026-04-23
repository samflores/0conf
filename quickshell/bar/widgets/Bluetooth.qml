import QtQuick
import QtQuick.Layouts
import "../../theme"
import "../../panels"
import "../../services"
import "../../utils"

MouseArea {
    id: root

    required property var barScreen

    visible: Bluetooth.available
    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight
    cursorShape: Qt.PointingHandCursor
    hoverEnabled: true

    readonly property int connectedCount: {
        var devs = Bluetooth.adapter?.devices?.values ?? []
        var n = 0
        for (var i = 0; i < devs.length; i++) {
            if (devs[i].connected) n++
        }
        return n
    }

    onClicked: PanelState.toggle("bluetooth", "right", root.barScreen)

    RowLayout {
        id: row
        spacing: 4

        Text {
            text: Bluetooth.powered ? Icons.systemIcons.bluetoothOn : Icons.systemIcons.bluetoothOff
            color: {
                if (PanelState.openPanel === "bluetooth") return Theme.accent
                return Bluetooth.powered ? Theme.fg : Theme.fgDim
            }
            font.family: Theme.fontFamily
            font.pixelSize: Theme.iconSize
        }

        Text {
            text: root.connectedCount + (root.connectedCount === 1 ? " device" : " devices")
            visible: Bluetooth.powered && root.containsMouse
            color: Theme.fg
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
        }
    }
}
