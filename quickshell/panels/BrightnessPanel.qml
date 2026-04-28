import QtQuick
import QtQuick.Layouts
import "../theme"
import "../services"
import "../utils"

Panel {
    id: root

    name: "brightness"
    side: "right"
    contentPadding: 12

    RowLayout {
        spacing: 10
        Layout.fillWidth: true

        Text {
            text: Icons.systemIcons.brightness
            color: Theme.fg
            font.family: Theme.fontFamily
            font.pixelSize: Theme.iconSize + 2
        }

        PanelSlider {
            Layout.fillWidth: true
            implicitWidth: 220
            from: 1
            to: 100
            value: Brightness.percent
            onMoved: function(v) { Brightness.set(v) }
        }

        Text {
            text: Brightness.percent + "%"
            color: Theme.fgDim
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
            Layout.preferredWidth: 36
            horizontalAlignment: Text.AlignRight
        }
    }
}
