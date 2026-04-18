pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Bluetooth

Singleton {
    id: root

    readonly property var adapter: Bluetooth.defaultAdapter
    readonly property bool available: adapter !== null
    readonly property bool powered: !!adapter?.enabled

    function toggle() {
        if (adapter) adapter.enabled = !adapter.enabled
    }
}
