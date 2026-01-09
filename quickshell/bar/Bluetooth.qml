import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Bluetooth

MouseArea {
    width: bluetoothText.implicitWidth
    height: bluetoothText.implicitHeight
    cursorShape: Qt.PointingHandCursor

    onClicked: {
        wiremixProcess.running = true;
    }

    Process {
        id: wiremixProcess
        command: ["ghostty", "--class=tui.tools.bluetui", "-e", "bluetui"]
        running: false
    }

    Text {
        id: bluetoothText
        text: Bluetooth.defaultAdapter?.enabled ? "" : "󰂲"
        font.pixelSize: 14
        font.family: "monospace"
        color: "#cdd6f4"
    }
}
