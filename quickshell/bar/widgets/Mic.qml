import QtQuick
import "../../theme"
import "../../services"
import "../../utils"

MouseArea {
    id: root

    implicitWidth: icon.implicitWidth
    implicitHeight: icon.implicitHeight
    cursorShape: Qt.PointingHandCursor

    onClicked: Audio.toggleMicMute()

    Text {
        id: icon
        text: Audio.micMuted ? Icons.systemIcons.micMute : Icons.systemIcons.mic
        color: Audio.micMuted ? Theme.fgDim : Theme.fg
        font.family: Theme.fontFamily
        font.pixelSize: Theme.iconSize
    }
}
