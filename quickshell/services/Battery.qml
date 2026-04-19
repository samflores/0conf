pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.UPower

Singleton {
    id: root

    readonly property var device: UPower.displayDevice
    readonly property bool present: !!device?.isPresent && device?.isLaptopBattery
    readonly property int percent: present ? Math.round(device.percentage) : 0
    readonly property bool charging: present && device.state === UPowerDeviceState.Charging
    readonly property bool full: present && device.state === UPowerDeviceState.FullyCharged

    // Seconds until empty/full; 0 if unknown or not applicable.
    readonly property int timeToEmpty: present ? (device.timeToEmpty ?? 0) : 0
    readonly property int timeToFull: present ? (device.timeToFull ?? 0) : 0
}
