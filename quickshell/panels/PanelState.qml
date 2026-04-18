pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    property string openPanel: ""
    property string openSide: ""
    property var openScreen: null
    property real openLeft: 0
    property real openRight: 0
    property real openHeight: 0
    property real openWidth: 0
    // Squish factor (0..1, 1 = at rest) applied to width during bounce.
    property real openXScale: 1.0

    readonly property bool touchesLeft: openPanel !== "" && openSide === "left"
    readonly property bool touchesRight: openPanel !== "" && openSide === "right"

    function toggle(name, side, screen) {
        if (openPanel === name && openScreen === screen) {
            close()
        } else {
            openPanel = name
            openSide = side
            openScreen = screen
        }
    }

    function close() {
        openPanel = ""
        openSide = ""
        openScreen = null
        openLeft = 0
        openRight = 0
        openWidth = 0
        openHeight = 0
        openXScale = 1.0
    }
}
