import QtQuick
import QtQuick.Layouts
import "../theme"
import "../services"
import "../utils"

Panel {
    id: root

    name: "battery"
    side: "right"
    contentPadding: 12

    function fmtDuration(seconds) {
        if (!seconds || seconds <= 0) return ""
        var h = Math.floor(seconds / 3600)
        var m = Math.floor((seconds % 3600) / 60)
        if (h > 0 && m > 0) return h + "h " + m + "m"
        if (h > 0) return h + "h"
        return m + "m"
    }

    ColumnLayout {
        spacing: 10

        RowLayout {
            spacing: 12
            Layout.fillWidth: true

            Text {
                text: {
                    if (Battery.charging) return Icons.systemIcons.batteryCharging
                    var p = Battery.percent
                    if (p >= 85) return Icons.systemIcons.batteryFull
                    if (p >= 60) return Icons.systemIcons.batteryThreeQ
                    if (p >= 35) return Icons.systemIcons.batteryHalf
                    if (p >= 15) return Icons.systemIcons.batteryQuarter
                    return Icons.systemIcons.batteryEmpty
                }
                color: {
                    if (Battery.charging) return Theme.ok
                    if (Battery.percent <= 15) return Theme.err
                    return Theme.fg
                }
                font.family: Theme.fontFamily
                font.pixelSize: Theme.iconSize + 10
            }

            ColumnLayout {
                spacing: 2
                Layout.fillWidth: true

                Text {
                    text: Battery.percent + "%"
                    color: Theme.fg
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize + 4
                    font.bold: true
                }
                Text {
                    text: {
                        if (Battery.full) return "Fully charged"
                        if (Battery.charging) {
                            var t = root.fmtDuration(Battery.timeToFull)
                            return t ? "Charging · " + t + " to full" : "Charging"
                        }
                        var t2 = root.fmtDuration(Battery.timeToEmpty)
                        return t2 ? t2 + " remaining" : "On battery"
                    }
                    color: Theme.fgDim
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                }
            }
        }

        // Progress bar
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredWidth: 240
            implicitHeight: 6
            radius: 3
            color: Theme.surface

            Rectangle {
                width: parent.width * Battery.percent / 100
                height: parent.height
                radius: 3
                color: {
                    if (Battery.charging) return Theme.ok
                    if (Battery.percent <= 15) return Theme.err
                    return Theme.accent
                }
            }
        }
    }
}
