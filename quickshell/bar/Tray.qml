import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray

Repeater {
    id: items

    model: SystemTray.items

    TrayItem {}
}
