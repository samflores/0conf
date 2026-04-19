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
    readonly property int percent: present ? Math.round(device.percentage) : 0
    readonly property bool charging: present && device.state === UPowerDeviceState.Charging
    readonly property bool full: present && device.state === UPowerDeviceState.FullyCharged

    readonly property int timeToEmpty: present ? (device.timeToEmpty ?? 0) : 0
    readonly property int timeToFull: present ? (device.timeToFull ?? 0) : 0

    function dump() {
        var devs = UPower.devices?.values ?? []
        console.info("Battery: devices count=", devs.length, "onBattery=", UPower.onBattery)
        for (var i = 0; i < devs.length; i++) {
            var d = devs[i]
            console.info("  [", i, "] type=", d.type, "isPresent=", d.isPresent,
                "isLaptop=", d.isLaptopBattery, "model=", d.model,
                "nativePath=", d.nativePath, "percentage=", d.percentage, "state=", d.state)
        }
    }

    Component.onCompleted: {
        dump()
        pollTimer.start()
    }

    Timer {
        id: pollTimer
        interval: 1000
        repeat: true
        onTriggered: root.dump()
    }
}
