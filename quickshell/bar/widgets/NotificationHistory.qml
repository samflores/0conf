import QtQuick
import "../../theme"
import "../../utils"

MouseArea {
    id: root

    implicitWidth: icon.implicitWidth
    implicitHeight: icon.implicitHeight
    cursorShape: Qt.PointingHandCursor
    hoverEnabled: true
    // Stubbed until we wire a notification daemon + history panel.
    onClicked: {}

    Text {
        id: icon
        text: Icons.systemIcons.notifications
        color: Theme.fgDim
        font.family: Theme.fontFamily
        font.pixelSize: Theme.iconSize
    }
}
