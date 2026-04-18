import QtQuick
import QtQuick.Layouts
import "../../theme"
import "../../panels"
import "../../services"
import "../../utils"

MouseArea {
    id: root

    required property var barScreen

    visible: Media.active
    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight
    cursorShape: Qt.PointingHandCursor
    acceptedButtons: Qt.LeftButton

    onClicked: PanelState.toggle("media", "center", root.barScreen)
    onWheel: function(wheel) {
        if (wheel.angleDelta.y > 0) Media.next()
        else if (wheel.angleDelta.y < 0) Media.prev()
        wheel.accepted = true
    }

    RowLayout {
        id: row
        spacing: 6

        Text {
            text: Icons.systemIcons.media
            color: PanelState.openPanel === "media" ? Theme.accent : Theme.fg
            font.family: Theme.fontFamily
            font.pixelSize: Theme.iconSize
        }

        Text {
            visible: Media.title.length > 0
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
