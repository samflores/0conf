import QtQuick
import QtQuick.Layouts
import "../theme"
import "../services"
import "../utils"

Panel {
    id: root

    name: "powerprofile"
    side: "right"

    function glyphFor(p) {
        if (p === "performance") return Icons.systemIcons.perfPerformance
        if (p === "power-saver") return Icons.systemIcons.perfPowerSaver
        return Icons.systemIcons.perfBalanced
    }

    function labelFor(p) {
        if (p === "performance") return "Performance"
        if (p === "power-saver") return "Power saver"
        if (p === "balanced") return "Balanced"
        return p
    }

    ColumnLayout {
        spacing: 0

        Repeater {
            model: PowerProfile.profiles

            MouseArea {
                readonly property bool active: PowerProfile.active === modelData

                Layout.fillWidth: true
                implicitWidth: row.implicitWidth + 24
                implicitHeight: row.implicitHeight + 12
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onClicked: PowerProfile.set(modelData)

                Rectangle {
                    anchors.fill: parent
                    color: parent.containsMouse ? Theme.bgAlt : "transparent"
                    radius: 6
                }

                RowLayout {
                    id: row
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    spacing: 10

                    Text {
                        text: root.glyphFor(modelData)
                        color: parent.parent.active ? Theme.accent : Theme.fg
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.iconSize
                    }
                    Text {
                        text: root.labelFor(modelData)
                        color: Theme.fg
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSize
                        Layout.fillWidth: true
                    }
                    Text {
                        text: ""
                        color: Theme.accent
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSize
                        visible: parent.parent.active
                    }
                }
            }
        }
    }
}
