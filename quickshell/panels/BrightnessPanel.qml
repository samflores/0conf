import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
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

        Slider {
            id: slider
            Layout.fillWidth: true
            implicitWidth: 220
            from: 1
            to: 100
            value: Brightness.percent
            onMoved: Brightness.set(value)

            background: Rectangle {
                x: slider.leftPadding
                y: slider.topPadding + slider.availableHeight / 2 - 2
                width: slider.availableWidth
                height: 4
                radius: 2
                color: Theme.surface
                Rectangle {
                    width: slider.visualPosition * parent.width
                    height: parent.height
                    color: Theme.accent
                    radius: 2
                }
            }
            handle: Rectangle {
                x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
                y: slider.topPadding + slider.availableHeight / 2 - height / 2
                width: 12
                height: 12
                radius: 6
                color: Theme.fg
                border.color: Theme.accent
                border.width: 1
            }
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
