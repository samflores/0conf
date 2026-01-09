import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower

MouseArea {
    width: powerText.implicitWidth
    height: powerText.implicitHeight
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
        id: powerText
        text: ""
        font.pixelSize: 14
        font.family: "monospace"
        color: "#cdd6f4"
    }
}
