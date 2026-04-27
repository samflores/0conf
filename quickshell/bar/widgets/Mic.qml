import QtQuick
import QtQuick.Layouts
import "../../theme"
import "../../panels"
import "../../services"
import "../../utils"

MouseArea {
    id: root

    required property var barScreen

    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight
    cursorShape: Qt.PointingHandCursor
    acceptedButtons: Qt.LeftButton | Qt.MiddleButton
    hoverEnabled: true

    onClicked: function(mouse) {
        if (mouse.button === Qt.MiddleButton) {
            Audio.toggleMicMute()
        } else {
            PanelState.toggle("mic", "right", root.barScreen)
        }
    }

    RowLayout {
        id: row
        spacing: 4

        Text {
            text: Audio.micMuted ? Icons.systemIcons.micMute : Icons.systemIcons.mic
            color: {
                if (PanelState.openPanel === "mic") return Theme.accent
                return Audio.micMuted ? Theme.fgDim : Theme.fg
            }
            font.family: Theme.fontFamily
            font.pixelSize: Theme.iconSize
        }

        Text {
            text: Audio.micMuted ? "mute" : Audio.micVolume + "%"
            visible: root.containsMouse
            color: Theme.fg
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
        }
    }
}
