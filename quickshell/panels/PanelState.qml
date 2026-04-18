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
    }
}
