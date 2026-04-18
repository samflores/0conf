import QtQuick
import QtQuick.Layouts
import "../../theme"
import "../../services"
import "../../utils"

MouseArea {
    id: root

    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight
    cursorShape: Qt.PointingHandCursor
    acceptedButtons: Qt.LeftButton

    onClicked: Audio.toggleMute()
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
            color: Audio.muted ? Theme.fgDim : Theme.fg
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
