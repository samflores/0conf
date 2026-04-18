import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray

RowLayout {
    spacing: 6

    Repeater {
        model: SystemTray.items

        TrayItem {}
    }
}
