import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import "../theme"
import "../utils"

Panel {
    id: root

    name: "tray"
    side: "right"
    contentPadding: 6

    // Stack of currently-open menu handles. Empty = tray root list.
    property var menuStack: []
    // Parallel stack of titles for the breadcrumb header.
    property var titleStack: []

    onOpenChanged: {
        if (!open) {
            menuStack = []
            titleStack = []
        }
    }

    function resolveIcon(icon) {
        if (!icon) return ""
        if (icon.indexOf("?path=") !== -1) {
            var parts = icon.split("?path=")
            var name = parts[0]
            var path = parts[1]
            return Qt.resolvedUrl(path + "/" + name.slice(name.lastIndexOf("/") + 1))
        }
        return icon
    }

    function pushMenu(handle, title) {
        if (!handle) return
        menuStack = menuStack.concat([handle])
        titleStack = titleStack.concat([title || ""])
    }

    function popMenu() {
        menuStack = menuStack.slice(0, -1)
        titleStack = titleStack.slice(0, -1)
    }

    readonly property var currentMenu: menuStack.length > 0 ? menuStack[menuStack.length - 1] : null

    // Opener tied to the top-of-stack menu. Its children drive the view.
    QsMenuOpener {
        id: opener
        menu: root.currentMenu
    }

    ColumnLayout {
        id: contentCol
        spacing: 2

        // Header (only when navigated into a menu)
        MouseArea {
            visible: root.menuStack.length > 0
            Layout.fillWidth: true
            implicitWidth: headerRow.implicitWidth + 16
            implicitHeight: 26
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            onClicked: root.popMenu()

            Rectangle {
                anchors.fill: parent
                radius: 6
                color: parent.containsMouse ? Theme.bgAlt : "transparent"
            }

            RowLayout {
                id: headerRow
                anchors.fill: parent
                anchors.leftMargin: 6
                anchors.rightMargin: 8
                spacing: 8

                Text {
                    text: "\uf053"  // fa-chevron-left
                    color: Theme.fgDim
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                }
                Text {
                    text: root.titleStack.length > 0
                        ? root.titleStack[root.titleStack.length - 1]
                        : ""
                    color: Theme.fg
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                    font.bold: true
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                }
            }
        }

        // --- Root view: tray items list ---
        Repeater {
            model: root.menuStack.length === 0 ? SystemTray.items : null

            MouseArea {
                required property SystemTrayItem modelData

                Layout.fillWidth: true
                implicitWidth: trayRow.implicitWidth + 16
                implicitHeight: 30
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                hoverEnabled: true
                onClicked: function(mouse) {
                    if (mouse.button === Qt.RightButton) {
                        if (modelData.hasMenu && modelData.menu) {
                            root.pushMenu(modelData.menu,
                                modelData.tooltipTitle || modelData.title || modelData.id)
                        }
                    } else {
                        modelData.activate()
                    }
                }

                Rectangle {
                    anchors.fill: parent
                    radius: 6
                    color: parent.containsMouse ? Theme.bgAlt : "transparent"
                }

                RowLayout {
                    id: trayRow
                    anchors.fill: parent
                    anchors.leftMargin: 8
                    anchors.rightMargin: 8
                    spacing: 10

                    IconImage {
                        implicitWidth: 18
                        implicitHeight: 18
                        asynchronous: true
                        source: root.resolveIcon(modelData.icon)
                    }
                    Text {
                        text: modelData.tooltipTitle && modelData.tooltipTitle.length > 0
                            ? modelData.tooltipTitle
                            : (modelData.title || modelData.id)
                        color: Theme.fg
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSize
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                    }
                    Text {
                        visible: modelData.hasMenu
                        text: "⋯"
                        color: Theme.fgDim
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSize
                    }
                }
            }
        }

        // --- Menu view: opener.children of currentMenu ---
        Repeater {
            model: root.menuStack.length > 0 ? opener.children : null

            Loader {
                required property var modelData
                Layout.fillWidth: true

                sourceComponent: modelData.isSeparator ? sepComp : entryComp

                Component {
                    id: sepComp
                    Rectangle {
                        Layout.fillWidth: true
                        implicitHeight: 1
                        color: Theme.border
                    }
                }

                Component {
                    id: entryComp
                    MouseArea {
                        Layout.fillWidth: true
                        implicitWidth: entryRow.implicitWidth + 16
                        implicitHeight: 26
                        cursorShape: modelData.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                        enabled: modelData.enabled
                        hoverEnabled: true
                        onClicked: {
                            if (modelData.hasChildren) {
                                root.pushMenu(modelData, modelData.text)
                            } else {
                                modelData.triggered()
                                PanelState.close()
                            }
                        }

                        Rectangle {
                            anchors.fill: parent
                            radius: 6
                            color: parent.containsMouse && parent.enabled ? Theme.bgAlt : "transparent"
                        }

                        RowLayout {
                            id: entryRow
                            anchors.fill: parent
                            anchors.leftMargin: 8
                            anchors.rightMargin: 8
                            spacing: 8

                            // Leading: check/radio indicator, icon, or blank spacer
                            Item {
                                implicitWidth: 16
                                implicitHeight: 16

                                Text {
                                    visible: modelData.buttonType === 1 || modelData.buttonType === 2
                                    anchors.centerIn: parent
                                    text: modelData.checkState === Qt.Checked
                                        ? (modelData.buttonType === 2 ? "\uf192" : "\uf00c")
                                        : (modelData.buttonType === 2 ? "\uf111" : "")
                                    color: Theme.accent
                                    font.family: Theme.fontFamily
                                    font.pixelSize: Theme.fontSize - 2
                                }

                                IconImage {
                                    visible: modelData.buttonType === 0 && modelData.icon
                                    anchors.fill: parent
                                    asynchronous: true
                                    source: root.resolveIcon(modelData.icon)
                                }
                            }

                            Text {
                                text: modelData.text || ""
                                color: modelData.enabled ? Theme.fg : Theme.fgDim
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontSize
                                Layout.fillWidth: true
                                elide: Text.ElideRight
                            }

                            Text {
                                visible: modelData.hasChildren
                                text: "\uf054"  // fa-chevron-right
                                color: Theme.fgDim
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontSize - 2
                            }
                        }
                    }
                }
            }
        }
    }
}
