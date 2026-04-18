import QtQuick
import QtQuick.Layouts
import "../theme"
import "../services"
import "../utils"

Panel {
    id: root

    name: "network"
    side: "right"
    contentPadding: 12

    onOpenChanged: {
        if (open) Network.scan()
    }

    ColumnLayout {
        spacing: 8

        // Current status
        RowLayout {
            spacing: 10
            Layout.fillWidth: true

            Text {
                text: {
                    if (!Network.connected) return Icons.systemIcons.wifiOff
                    if (Network.signal >= 75) return Icons.systemIcons.wifiHigh
                    if (Network.signal >= 50) return Icons.systemIcons.wifiMid
                    return Icons.systemIcons.wifiLow
                }
                color: Network.connected ? Theme.accent : Theme.fgDim
                font.family: Theme.fontFamily
                font.pixelSize: Theme.iconSize + 4
            }

            ColumnLayout {
                spacing: 2
                Layout.fillWidth: true

                Text {
                    text: Network.connected ? Network.ssid : "Disconnected"
                    color: Theme.fg
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize + 1
                    font.bold: true
                }
                Text {
                    text: Network.connected ? "Signal: " + Network.signal + "%" : ""
                    visible: Network.connected
                    color: Theme.fgDim
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize - 1
                }
            }
        }

        // Available networks header
        RowLayout {
            Layout.fillWidth: true
            Layout.topMargin: 4

            Text {
                text: "Available networks"
                color: Theme.fgDim
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize - 1
                Layout.fillWidth: true
            }
            Text {
                visible: Network.scanning
                text: "scanning…"
                color: Theme.fgDim
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize - 1
            }
        }

        // Networks list
        Repeater {
            model: Network.networks

            MouseArea {
                readonly property bool known: Network.knownNetworks.indexOf(modelData) >= 0
                readonly property bool current: Network.connected && Network.ssid === modelData

                Layout.fillWidth: true
                implicitWidth: netRow.implicitWidth + 16
                implicitHeight: netRow.implicitHeight + 8
                cursorShape: known && !current ? Qt.PointingHandCursor : Qt.ArrowCursor
                hoverEnabled: true
                enabled: known && !current
                onClicked: Network.connectTo(modelData)

                Rectangle {
                    anchors.fill: parent
                    radius: 6
                    color: parent.containsMouse && parent.enabled ? Theme.bgAlt : "transparent"
                }

                RowLayout {
                    id: netRow
                    anchors.fill: parent
                    anchors.leftMargin: 8
                    anchors.rightMargin: 8
                    spacing: 8

                    Text {
                        text: parent.parent.current ? "\uf00c" : ""
                        color: Theme.accent
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSize
                        Layout.preferredWidth: 14
                    }
                    Text {
                        text: modelData
                        color: parent.parent.current ? Theme.fg
                            : parent.parent.known ? Theme.fg
                            : Theme.fgDim
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSize
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                    }
                    Text {
                        text: parent.parent.known ? "" : "unknown"
                        color: Theme.fgDim
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSize - 2
                        visible: text.length > 0
                    }
                }
            }
        }

        Text {
            visible: Network.networks.length === 0
            text: Network.scanning ? "Scanning…" : "No networks found"
            color: Theme.fgDim
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
            Layout.alignment: Qt.AlignHCenter
            topPadding: 4
            bottomPadding: 4
        }
    }
}
