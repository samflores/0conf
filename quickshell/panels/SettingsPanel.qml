import QtQuick
import QtQuick.Layouts
import "../theme"
import "../services"
import "../utils"

Panel {
    id: root

    name: "settings"
    side: "right"

    ColumnLayout {
        id: menu
        spacing: 0

        component Action: MouseArea {
            id: act
            property string label
            property string glyph
            signal activated()

            Layout.fillWidth: true
            implicitWidth: actRow.implicitWidth + 24
            implicitHeight: actRow.implicitHeight + 12
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true

            onClicked: act.activated()

            Rectangle {
                anchors.fill: parent
                color: act.containsMouse ? Theme.bgAlt : "transparent"
                radius: 6
            }

            RowLayout {
                id: actRow
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                spacing: 10

                Text {
                    text: act.glyph
                    color: Theme.fg
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.iconSize
                }
                Text {
                    text: act.label
                    color: Theme.fg
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                    Layout.fillWidth: true
                }
            }
        }

        component Toggle: MouseArea {
            id: tog
            property string label
            property string glyph
            property bool active
            signal activated()

            Layout.fillWidth: true
            implicitWidth: row.implicitWidth + 24
            implicitHeight: row.implicitHeight + 12
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true

            onClicked: tog.activated()

            Rectangle {
                anchors.fill: parent
                color: tog.containsMouse ? Theme.bgAlt : "transparent"
                radius: 6
            }

            RowLayout {
                id: row
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                spacing: 10

                Text {
                    text: tog.glyph
                    color: tog.active ? Theme.accent : Theme.fg
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.iconSize
                }
                Text {
                    text: tog.label
                    color: Theme.fg
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                    Layout.fillWidth: true
                }
                Text {
                    text: tog.active ? "on" : "off"
                    color: tog.active ? Theme.accent : Theme.fgDim
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize - 1
                }
            }
        }

        Toggle {
            label: Theme.dark ? "Dark theme" : "Light theme"
            glyph: Theme.dark ? Icons.systemIcons.themeDark : Icons.systemIcons.themeLight
            active: Theme.dark
            onActivated: ThemeState.toggle()
        }

        Toggle {
            label: "Night light"
            glyph: Icons.systemIcons.nightLight
            active: Nightlight.enabled
            visible: Nightlight.available
            onActivated: Nightlight.toggle()
        }

        Toggle {
            label: "Airplane mode"
            glyph: Airplane.enabled ? Icons.systemIcons.airplaneOn : Icons.systemIcons.airplaneOff
            active: Airplane.enabled
            onActivated: Airplane.toggle()
        }

        Action {
            label: "Wallpaper..."
            glyph: Icons.systemIcons.wallpaper
            onActivated: PanelState.toggle("wallpaper", "right", root.panelScreen)
        }
    }
}
