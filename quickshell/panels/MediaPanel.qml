import QtQuick
import QtQuick.Layouts
import "../theme"
import "../services"
import "../utils"

Panel {
    id: root

    name: "media"
    side: "center"
    contentPadding: 16

    // Live-refresh position while playing.
    property real displayPosition: Media.player?.position ?? 0
    Timer {
        interval: 500
        running: root.open && Media.active && Media.playing
        repeat: true
        onTriggered: root.displayPosition = Media.player?.position ?? 0
    }
    // Also refresh on pause/seek externally.
    Connections {
        target: Media.player
        function onPositionChanged() {
            root.displayPosition = Media.player?.position ?? 0
        }
    }

    function fmtTime(s) {
        if (s < 0 || !isFinite(s)) return "0:00"
        var total = Math.floor(s)
        var m = Math.floor(total / 60)
        var sec = total % 60
        return m + ":" + (sec < 10 ? "0" + sec : sec)
    }

    ColumnLayout {
        spacing: 12

        RowLayout {
            spacing: 14
            Layout.fillWidth: true

            // Album art
            Rectangle {
                implicitWidth: 96
                implicitHeight: 96
                radius: 6
                color: Theme.surface
                clip: true

                Image {
                    anchors.fill: parent
                    source: Media.art
                    fillMode: Image.PreserveAspectCrop
                    visible: status === Image.Ready
                    asynchronous: true
                }
                Text {
                    anchors.centerIn: parent
                    visible: !Media.art || parent.children[0].status !== Image.Ready
                    text: Icons.systemIcons.media
                    color: Theme.fgDim
                    font.family: Theme.fontFamily
                    font.pixelSize: 32
                }
            }

            // Text column: title / album / artist
            ColumnLayout {
                spacing: 4
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter

                Text {
                    text: Media.title || "Unknown title"
                    color: Theme.fg
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize + 2
                    font.bold: true
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                    Layout.maximumWidth: 280
                }
                Text {
                    text: Media.player?.trackAlbum || ""
                    visible: text.length > 0
                    color: Theme.fgDim
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                    Layout.maximumWidth: 280
                }
                Text {
                    text: Media.artist || ""
                    visible: text.length > 0
                    color: Theme.fgDim
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                    Layout.maximumWidth: 280
                }
            }
        }

        // Scrubber row
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2

            PanelSlider {
                Layout.fillWidth: true
                implicitWidth: 400
                from: 0
                to: Math.max(1, Media.player?.length ?? 0)
                value: root.displayPosition
                enabled: !!Media.player?.canSeek
                onMoved: function(v) {
                    if (Media.player && Media.player.canSeek) {
                        Media.player.position = v
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Text {
                    text: root.fmtTime(root.displayPosition)
                    color: Theme.fgDim
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize - 2
                    Layout.fillWidth: true
                }
                Text {
                    text: root.fmtTime(Media.player?.length ?? 0)
                    color: Theme.fgDim
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize - 2
                }
            }
        }

        // Controls row, centered
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 20

            MouseArea {
                implicitWidth: prevIcon.implicitWidth + 12
                implicitHeight: prevIcon.implicitHeight + 8
                cursorShape: Qt.PointingHandCursor
                enabled: !!Media.player?.canGoPrevious
                onClicked: Media.prev()
                Text {
                    id: prevIcon
                    anchors.centerIn: parent
                    text: Icons.systemIcons.prev
                    color: parent.enabled ? Theme.fg : Theme.fgDim
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.iconSize + 2
                }
            }

            MouseArea {
                implicitWidth: 36
                implicitHeight: 36
                cursorShape: Qt.PointingHandCursor
                enabled: !!Media.player?.canTogglePlaying
                onClicked: Media.playPause()
                Rectangle {
                    anchors.fill: parent
                    radius: width / 2
                    color: Theme.surface
                }
                Text {
                    anchors.centerIn: parent
                    text: Media.playing ? Icons.systemIcons.pause : Icons.systemIcons.play
                    color: Theme.fg
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.iconSize + 4
                }
            }

            MouseArea {
                implicitWidth: nextIcon.implicitWidth + 12
                implicitHeight: nextIcon.implicitHeight + 8
                cursorShape: Qt.PointingHandCursor
                enabled: !!Media.player?.canGoNext
                onClicked: Media.next()
                Text {
                    id: nextIcon
                    anchors.centerIn: parent
                    text: Icons.systemIcons.next
                    color: parent.enabled ? Theme.fg : Theme.fgDim
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.iconSize + 2
                }
            }
        }
    }
}
