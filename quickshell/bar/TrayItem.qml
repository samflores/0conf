pragma ComponentBehavior: Bound

import Quickshell.Services.SystemTray
import Quickshell.Widgets
import QtQuick



MouseArea {
    id: root

    required property SystemTrayItem modelData

    acceptedButtons: Qt.LeftButton | Qt.RightButton
    implicitWidth: 18
    implicitHeight: 18


    function getTrayIcon(id: string, icon: string): string {
        // for (const sub of Config.bar.tray.iconSubs)
        //     if (sub.id === id)
        //         return sub.image ? Qt.resolvedUrl(sub.image) : Quickshell.iconPath(sub.icon);

        if (icon.includes("?path=")) {
            const [name, path] = icon.split("?path=");
            icon = Qt.resolvedUrl(`${path}/${name.slice(name.lastIndexOf("/") + 1)}`);
        }
        return icon;
    }

    onClicked: event => {
        if (event.button === Qt.LeftButton)
            modelData.activate();
        else
            modelData.secondaryActivate();
    }

    IconImage {
        id: icon
        asynchronous: true

        anchors.fill: parent
        source: getTrayIcon(root.modelData.id, root.modelData.icon)
    }
}
