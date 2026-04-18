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

    onClicked: function(mouse) {
        if (mouse.button === Qt.MiddleButton) {
            Audio.toggleMute()
        } else {
            PanelState.toggle("volume", "right", root.barScreen)
        }
    }
    onWheel: function(wheel) {
        var delta = wheel.angleDelta.y > 0 ? 5 : -5
        Audio.setVolume(Audio.volume + delta)
        wheel.accepted = true
    }

    RowLayout {
        id: row
        spacing: 4

        Text {
            text: {
                if (Audio.muted || Audio.volume === 0) return Icons.systemIcons.volumeMute
                if (Audio.volume <= 33) return Icons.systemIcons.volumeLow
                if (Audio.volume <= 66) return Icons.systemIcons.volumeMid
                return Icons.systemIcons.volume
            }
            color: {
                if (PanelState.openPanel === "volume") return Theme.accent
                if (Audio.muted) return Theme.fgDim
                return Theme.fg
            }
            font.family: Theme.fontFamily
            font.pixelSize: Theme.iconSize
        }

        Text {
            text: Audio.volume + "%"
            visible: !Audio.muted
            color: Theme.fg
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
        }
    }
}
