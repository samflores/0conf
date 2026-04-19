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

    onClicked: PanelState.toggle("settings", "right", root.barScreen)

    Text {
        id: icon
        text: Icons.systemIcons.settings
        color: PanelState.openPanel === "settings" ? Theme.accent : Theme.fg
        font.family: Theme.fontFamily
        font.pixelSize: Theme.iconSize
    }
}
