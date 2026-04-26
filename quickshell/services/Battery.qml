pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.UPower

Singleton {
    id: root

    readonly property var device: {
        var devs = UPower.devices?.values ?? []
        for (var i = 0; i < devs.length; i++) {
            var d = devs[i]
            if (d.type === UPowerDeviceType.Battery && d.isPresent) return d
        }
        return null
    }

    readonly property bool present: device !== null

    // Quickshell's UPower binding normalises percentage to the 0..1 range.
    readonly property int percent: present ? Math.round((device.percentage ?? 0) * 100) : 0
    readonly property bool charging: present && device.state === UPowerDeviceState.Charging
    readonly property bool full: present && device.state === UPowerDeviceState.FullyCharged

    readonly property int timeToEmpty: present ? (device.timeToEmpty ?? 0) : 0
    readonly property int timeToFull: present ? (device.timeToFull ?? 0) : 0

    readonly property bool lowDischarging: present && !charging && percent <= 15 && percent > 0
}
