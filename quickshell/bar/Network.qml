import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower

MouseArea {
    width: networkText.implicitWidth
    height: networkText.implicitHeight
    cursorShape: Qt.PointingHandCursor

    onClicked: {
        wiremixProcess.running = true;
    }

    Process {
        id: wiremixProcess
        command: ["ghostty", "--class=tui.tools.impala", "-e", "impala"]
        running: false
    }

    Text {
        id: networkText
        text: "󰤨"
        font.pixelSize: 14
        font.family: "monospace"
        color: "#cdd6f4"
    }
}
