import QtQuick
import QtQuick.Layouts
import Quickshell.Bluetooth
import "../theme"
import "../services"
import "../utils"

Panel {
    id: root

    name: "bluetooth"
    side: "right"
    contentPadding: 12

    readonly property var adapter: Bluetooth.defaultAdapter
    readonly property var devices: adapter?.devices?.values ?? []

    ColumnLayout {
        spacing: 10

        // Power toggle row
        MouseArea {
            Layout.fillWidth: true
            implicitWidth: headerRow.implicitWidth + 20
            implicitHeight: headerRow.implicitHeight + 10
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            onClicked: Bluetooth.toggle()

            Rectangle {
                anchors.fill: parent
                radius: 6
                color: parent.containsMouse ? Theme.bgAlt : "transparent"
            }

            RowLayout {
                id: headerRow
                anchors.fill: parent
                anchors.leftMargin: 8
                anchors.rightMargin: 8
                spacing: 10

                Text {
                    text: Bluetooth.powered ? Icons.systemIcons.bluetoothOn : Icons.systemIcons.bluetoothOff
                    color: Bluetooth.powered ? Theme.accent : Theme.fgDim
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.iconSize + 2
                }
                Text {
                    text: Bluetooth.powered ? "Bluetooth on" : "Bluetooth off"
                    color: Theme.fg
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                    Layout.fillWidth: true
                }
            }
        }

        // Devices
        Text {
            text: "Devices"
            color: Theme.fgDim
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize - 1
            topPadding: 4
            visible: root.devices.length > 0
        }

        Repeater {
            model: root.devices

            MouseArea {
                Layout.fillWidth: true
                implicitWidth: deviceRow.implicitWidth + 16
                implicitHeight: deviceRow.implicitHeight + 8
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onClicked: {
                    if (modelData.connected) modelData.disconnect()
                    else if (modelData.paired) modelData.connect()
                }

                Rectangle {
                    anchors.fill: parent
                    radius: 6
                    color: parent.containsMouse ? Theme.bgAlt : "transparent"
                }

                RowLayout {
                    id: deviceRow
                    anchors.fill: parent
                    anchors.leftMargin: 8
                    anchors.rightMargin: 8
                    spacing: 8

                    Text {
                        text: modelData.connected ? "\uf00c" : ""
                        color: Theme.accent
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSize
                        Layout.preferredWidth: 14
                    }
                    Text {
                        text: modelData.name || modelData.address
                        color: modelData.connected ? Theme.fg : Theme.fgDim
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSize
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                    }
                }
            }
        }

        Text {
            text: "No devices"
            color: Theme.fgDim
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
            visible: root.devices.length === 0 && Bluetooth.powered
            Layout.alignment: Qt.AlignHCenter
            topPadding: 4
            bottomPadding: 4
        }
    }
}
