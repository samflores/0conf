import Quickshell
import QtQuick.Layouts
import Quickshell.Io
import QtQuick
import Niri 0.1
import "./bar"

ShellRoot {
    Variants {
        id: variants
        model: Quickshell.screens

        PanelWindow {
            property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 26
            color: "#1a1b26"

            Niri {
                id: niri
                Component.onCompleted: connect()

                onConnected: console.info("Connected to niri")
                onErrorOccurred: function(error) {
                    console.error("Niri error:", error)
                }
            }

            Rectangle {
                anchors.fill: parent
                color: "transparent"
                bottomLeftRadius: 8
                bottomRightRadius: 8

                RowLayout {
                    anchors {
                        left: parent.left
                        leftMargin: 12
                    }
                    Loader { 
                        active: true
                        sourceComponent: Workspaces {
                            screen: modelData
                        }
                    }
                }

                RowLayout {
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        verticalCenter: parent.verticalCenter
                    }


                    Text {
                        id: clock
                        text: "Hello, World!"
                        font.pixelSize: 12
                        font.family: "monospace"
                        color: "#cdd6f4"

                        Process {
                            id: dateProc

                            command: ["date", "+%a, %b %d • %H:%M"]
                            running: true

                            stdout: StdioCollector {
                                onStreamFinished: clock.text = this.text.trim()
                            }
                        }

                        Timer {
                            interval: 1000
                            running: true
                            repeat: true
                            onTriggered: dateProc.running = true
                        }
                    }
                }

                RowLayout {
                    anchors {
                        verticalCenter: parent.verticalCenter
                        right: parent.right
                        rightMargin: 12
                    }
                    spacing: 5
                    // Loader { active: true; sourceComponent: Tray {} }
                    Loader { active: true; sourceComponent: Bluetooth {} }
                    Loader { active: true; sourceComponent: Network {} }
                    Loader { active: true; sourceComponent: Audio {} }
                    Loader { active: true; sourceComponent: Power {} }
                }
            }

        }
    }
}
