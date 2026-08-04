import QtQuick
import QtQuick.Layouts
import "../../theme"
import "../../services"
import "../../utils"

Item {
    id: root

    required property var barScreen

    visible: Autocorrect.on
    implicitWidth: icon.implicitWidth
    implicitHeight: icon.implicitHeight

    Text {
        id: icon
        text: Icons.systemIcons.autocorrect
        color: Theme.warn
        font.family: Theme.fontFamily
        font.pixelSize: Theme.iconSize
    }
}
