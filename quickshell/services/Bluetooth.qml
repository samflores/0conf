pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Bluetooth as Bluez

Singleton {
    id: root

    readonly property var adapter: Bluez.Bluetooth.defaultAdapter
    readonly property bool available: adapter !== null
    readonly property bool powered: {
        if (!adapter) return false
        if (adapter.state === Bluez.BluetoothAdapterState.Enabled) return true
        if (adapter.state === Bluez.BluetoothAdapterState.Enabling) return true
        return !!adapter.enabled
    }

    function toggle() {
        if (adapter) adapter.enabled = !adapter.enabled
    }
}
