import QtQuick
import "../../theme"
import "../../panels"
import "../../utils"

MouseArea {
    id: root

    required property var barScreen

    implicitWidth: icon.implicitWidth
    implicitHeight: icon.implicitHeight
    cursorShape: Qt.PointingHandCursor

    onClicked: PanelState.toggle("power", "right", root.barScreen)

    Text {
        id: icon
        text: Icons.systemIcons.power
        color: PanelState.openPanel === "power" ? Theme.accent : Theme.fg
        font.family: Theme.fontFamily
        font.pixelSize: Theme.iconSize
    }
}
