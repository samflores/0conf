import QtQuick
import Quickshell.Services.SystemTray
import "../../theme"
import "../../panels"
import "../../utils"

MouseArea {
    id: root

    required property var barScreen

    visible: SystemTray.items.values.length > 0
    implicitWidth: icon.implicitWidth
    implicitHeight: icon.implicitHeight
    cursorShape: Qt.PointingHandCursor

    onClicked: PanelState.toggle("tray", "right", root.barScreen)

    Text {
        id: icon
        text: Icons.systemIcons.tray
        color: PanelState.openPanel === "tray" ? Theme.accent : Theme.fg
        font.family: Theme.fontFamily
        font.pixelSize: Theme.iconSize
    }
}
