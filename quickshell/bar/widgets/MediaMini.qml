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

    onClicked: Media.playPause()

    WheelHandler {
        onWheel: function(event) {
            if (event.angleDelta.y > 0) Media.next()
            else if (event.angleDelta.y < 0) Media.prev()
        }
    }

    RowLayout {
        id: row
        spacing: 6

        Text {
            text: Icons.systemIcons.media
            color: Media.active ? Theme.fg : Theme.fgDim
            font.family: Theme.fontFamily
            font.pixelSize: Theme.iconSize
        }

        Text {
            visible: Media.active && Media.title.length > 0
            text: {
                var t = Media.title
                return t.length > 30 ? t.substring(0, 27) + "…" : t
            }
            color: Theme.fg
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
        }
    }
}
