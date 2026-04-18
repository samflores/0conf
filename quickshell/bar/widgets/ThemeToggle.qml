import QtQuick
import "../../theme"
import "../../utils"

MouseArea {
    id: root

    implicitWidth: icon.implicitWidth
    implicitHeight: icon.implicitHeight
    cursorShape: Qt.PointingHandCursor

    onClicked: ThemeState.toggle()

    Text {
        id: icon
        text: Theme.dark ? Icons.systemIcons.themeDark : Icons.systemIcons.themeLight
        color: Theme.fg
        font.family: Theme.fontFamily
        font.pixelSize: Theme.iconSize
    }
}
