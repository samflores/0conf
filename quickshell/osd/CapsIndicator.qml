import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import "../theme"
import "../services"
import "../utils"

PanelWindow {
    id: root

    required property var modelData
    screen: modelData

    property string focusedOutput: ""
    readonly property bool isFocusedScreen: focusedOutput === screen?.name
    readonly property bool capsVisible: Capslock.capsOn && isFocusedScreen

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.exclusionMode: ExclusionMode.Ignore

    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }
    color: "transparent"
    mask: Region {}

    Process {
        id: focusedOutputProc
        command: ["sh", "-c", "niri msg --json focused-output"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    var obj = JSON.parse(this.text)
                    root.focusedOutput = obj.name || ""
                } catch (e) {}
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: focusedOutputProc.running = true
    }

    Rectangle {
        id: body
        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height - height - 16
        implicitWidth: row.implicitWidth + 28
        implicitHeight: 36
        radius: Theme.pillRadius
        color: Theme.bg
        border.width: 1
        border.color: Theme.warn

        opacity: root.capsVisible ? 0.95 : 0
        Behavior on opacity { NumberAnimation { duration: 200 } }

        RowLayout {
            id: row
            anchors.centerIn: parent
            spacing: 8

            Text {
                text: Icons.systemIcons.lock
                color: Theme.warn
                font.family: Theme.fontFamily
                font.pixelSize: Theme.iconSize
            }

            Text {
                text: "Caps Lock"
                color: Theme.fg
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize
            }
        }
    }
}
