import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.services

MouseArea {
    width: audioText.implicitWidth
    height: audioText.implicitHeight
    cursorShape: Qt.PointingHandCursor

    onClicked: {
        wiremixProcess.running = true;
    }

    Process {
        id: wiremixProcess
        command: ["ghostty", "--class=tui.tools.wiremix", "-e", "wiremix"]
        running: false
    }

    Text {
        id: audioText
        text: Audio.muted ? "" : (Audio.volume <= 0.3 ? "" : ( Audio.volume <= 0.6 ? "" : "" ))
        font.pixelSize: 14
        font.family: "monospace"
        color: "#cdd6f4"
    }
}
