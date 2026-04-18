import QtQuick
import "../../theme"
import "../../panels"
import "../../services"
import "../../utils"

MouseArea {
    id: root

    required property var barScreen

    implicitWidth: icon.implicitWidth
    implicitHeight: icon.implicitHeight
    cursorShape: Qt.PointingHandCursor
    acceptedButtons: Qt.LeftButton | Qt.MiddleButton

    onClicked: function(mouse) {
        if (mouse.button === Qt.MiddleButton) {
            Audio.toggleMicMute()
        } else {
            PanelState.toggle("mic", "right", root.barScreen)
        }
    }

    Text {
        id: icon
        text: Audio.micMuted ? Icons.systemIcons.micMute : Icons.systemIcons.mic
        color: {
            if (PanelState.openPanel === "mic") return Theme.accent
            return Audio.micMuted ? Theme.fgDim : Theme.fg
        }
        font.family: Theme.fontFamily
        font.pixelSize: Theme.iconSize
    }
}
