import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import Quickshell
import Quickshell.Wayland
import Niri 0.1
import "../theme"
import "../panels"
import "./widgets"

PanelWindow {
    id: root

    required property var modelData
    screen: modelData

    readonly property bool panelOnThisScreen: PanelState.openPanel !== "" && PanelState.openScreen === root.screen

    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.exclusionMode: ExclusionMode.Ignore

    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }

    color: "transparent"

    // Click-through mask: bar + open panel are the only input areas.
    mask: Region {
        x: 0
        y: 0
        width: root.width
        height: root.height
        intersection: Intersection.Xor

        Region {
            x: 0
            y: 0
            width: barArea.width
            height: barArea.height
            intersection: Intersection.Subtract
        }

        Region {
            // Cover everything below bar when a panel is open on THIS
            // screen so click-outside dismisses.
            x: 0
            y: Theme.barHeight
            width: root.panelOnThisScreen ? root.width : 0
            height: root.panelOnThisScreen ? root.height - Theme.barHeight : 0
            intersection: Intersection.Subtract
        }
    }

    Niri {
        id: niri
        Component.onCompleted: connect()
        onErrorOccurred: function(error) { console.error("Niri error:", error) }
    }

    // The bar itself.
    Rectangle {
        id: barArea
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: Theme.barHeight
        color: Theme.bg

        RowLayout {
            id: leftRow
            anchors.left: parent.left
            anchors.leftMargin: 12
            anchors.verticalCenter: parent.verticalCenter
            spacing: Theme.widgetGap

            Workspaces {
                screen: root.screen
                niri: niri
                barScreen: root.screen
            }

            ActiveWindow {
                niri: niri
            }
        }

        RowLayout {
            id: centerRow
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            spacing: Theme.widgetGap * 4

            Clock {
                barScreen: root.screen
            }
            MediaMini {
                barScreen: root.screen
            }
        }

        RowLayout {
            id: rightRow
            anchors.right: parent.right
            anchors.rightMargin: 12
            anchors.verticalCenter: parent.verticalCenter
            spacing: Theme.widgetGap

            Tray {
                barScreen: root.screen
            }
            Battery {
                barScreen: root.screen
            }
            Brightness {
                barScreen: root.screen
            }
            Mic {
                barScreen: root.screen
            }
            Volume {
                barScreen: root.screen
            }
            Network {
                barScreen: root.screen
            }
            Bluetooth {
                barScreen: root.screen
            }
            ThemeToggle {}
            Power {
                barScreen: root.screen
            }
        }
    }

    // Corner geometry helpers. The "left-edge corner" path is bar-color
    // filling the top-right triangle of a pillRadius square, with the
    // hypotenuse carved by a concave arc toward (0,0). Used for:
    //   - screen's left edge (at bar bottom)
    //   - popup's top-right wrap (when popup is on the left half of bar)
    // The "right-edge corner" path is the mirror.

    component LeftEdgeCorner: Shape {
        width: Theme.pillRadius
        height: Theme.pillRadius
        preferredRendererType: Shape.CurveRenderer

        ShapePath {
            strokeWidth: -1
            fillColor: Theme.bg
            startX: 0
            startY: 0
            PathLine { x: Theme.pillRadius; y: 0 }
            PathArc {
                x: 0; y: Theme.pillRadius
                radiusX: Theme.pillRadius
                radiusY: Theme.pillRadius
                direction: PathArc.Counterclockwise
            }
            PathLine { x: 0; y: 0 }
        }
    }

    component RightEdgeCorner: Shape {
        width: Theme.pillRadius
        height: Theme.pillRadius
        preferredRendererType: Shape.CurveRenderer

        ShapePath {
            strokeWidth: -1
            fillColor: Theme.bg
            startX: 0
            startY: 0
            PathLine { x: Theme.pillRadius; y: 0 }
            PathLine { x: Theme.pillRadius; y: Theme.pillRadius }
            PathArc {
                x: 0; y: 0
                radiusX: Theme.pillRadius
                radiusY: Theme.pillRadius
                direction: PathArc.Counterclockwise
            }
        }
    }

    // Screen-left concave at bar bottom. Drops to popup bottom when a
    // left-aligned popup is open on this screen.
    LeftEdgeCorner {
        anchors.left: parent.left
        y: Theme.barHeight + (root.panelOnThisScreen && PanelState.touchesLeft ? PanelState.openHeight : 0)
    }

    // Screen-right concave at bar bottom. Drops to popup bottom when a
    // right-aligned popup is open on this screen.
    RightEdgeCorner {
        anchors.right: parent.right
        y: Theme.barHeight + (root.panelOnThisScreen && PanelState.touchesRight ? PanelState.openHeight : 0)
    }

    // The wrap shapes at popup's top-left and top-right corners are
    // drawn inside Panel itself so they transform with it.

    // Panel host — panels mount here. Each panel positions itself via
    // its `side` property. Only one panel is visible at a time.
    Item {
        id: panelHost
        anchors.top: barArea.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        PowerMenu {
            panelScreen: root.screen
        }
        CalendarPanel {
            panelScreen: root.screen
        }
        MediaPanel {
            panelScreen: root.screen
        }
        VolumePanel {
            panelScreen: root.screen
        }
        BluetoothPanel {
            panelScreen: root.screen
        }
        NetworkPanel {
            panelScreen: root.screen
        }
        MicPanel {
            panelScreen: root.screen
        }
        WorkspacesPicker {
            panelScreen: root.screen
            niri: niri
        }
        TrayPanel {
            panelScreen: root.screen
        }
        BrightnessPanel {
            panelScreen: root.screen
        }
        BatteryPanel {
            panelScreen: root.screen
        }
    }

    // Dismiss panels when clicking outside them.
    MouseArea {
        anchors.fill: parent
        enabled: PanelState.openPanel !== ""
        z: -1
        onClicked: PanelState.close()
    }
}
