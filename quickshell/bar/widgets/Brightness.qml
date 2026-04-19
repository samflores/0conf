import QtQuick
import QtQuick.Layouts
import "../../theme"
import "../../panels"
import "../../services"
import "../../utils"

MouseArea {
    id: root

    required property var barScreen

    visible: Brightness.available
    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight
    cursorShape: Qt.PointingHandCursor

    onClicked: PanelState.toggle("brightness", "right", root.barScreen)
    onWheel: function(wheel) {
        var delta = wheel.angleDelta.y > 0 ? 5 : -5
        Brightness.set(Brightness.percent + delta)
        wheel.accepted = true
    }

    RowLayout {
        id: row
        spacing: 4

        Text {
            text: Icons.systemIcons.brightness
            color: PanelState.openPanel === "brightness" ? Theme.accent : Theme.fg
            font.family: Theme.fontFamily
            font.pixelSize: Theme.iconSize
        }

        Text {
            text: Brightness.percent + "%"
            color: Theme.fg
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
        }
    }
}
