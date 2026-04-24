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
    readonly property bool layerGrab: Notifications.layerFocused && isFocusedScreen

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.exclusionMode: ExclusionMode.Ignore
    WlrLayershell.keyboardFocus: root.layerGrab ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }
    color: "transparent"

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

    // Click-through except where popups sit.
    mask: Region {
        Region {
            x: stack.x
            y: stack.y
            width: stack.width
            height: stack.height
        }
    }

    readonly property var actionKeyOrder: [
        Qt.Key_N, Qt.Key_T, Qt.Key_E, Qt.Key_S,
        Qt.Key_I, Qt.Key_R, Qt.Key_O, Qt.Key_A
    ]

    Item {
        id: keyCapture
        anchors.fill: parent
        focus: root.layerGrab
        visible: root.layerGrab

        Keys.onPressed: function(e) {
            if (e.modifiers & Qt.ControlModifier) {
                if (e.key === Qt.Key_N) { Notifications.focusNext(); e.accepted = true; return }
                if (e.key === Qt.Key_P) { Notifications.focusPrev(); e.accepted = true; return }
            }
            if (e.key === Qt.Key_Escape) {
                if (e.modifiers & Qt.ShiftModifier) Notifications.dismissAll()
                else Notifications.dismissFocused()
                if (Notifications.items.length === 0) Notifications.releaseFocus()
                e.accepted = true
                return
            }
            // Home-row keys invoke the nth action on the focused popup.
            if (!(e.modifiers & (Qt.ControlModifier | Qt.AltModifier | Qt.MetaModifier))) {
                var idx = root.actionKeyOrder.indexOf(e.key)
                if (idx >= 0) {
                    Notifications.invokeAction(idx)
                    e.accepted = true
                    return
                }
            }
        }
    }

    ColumnLayout {
        id: stack
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 12
        anchors.bottomMargin: 12
        spacing: 8
        visible: root.isFocusedScreen && Notifications.items.length > 0

        Repeater {
            model: Notifications.items

            NotificationPopup {
                required property int index
                required property var modelData
                notif: modelData
                popupIndex: index
            }
        }
    }
}
