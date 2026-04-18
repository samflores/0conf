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
            }

            ActiveWindow {
                niri: niri
            }
        }

        RowLayout {
            id: centerRow
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            spacing: Theme.widgetGap

            Clock {}
            MediaMini {}
        }

        RowLayout {
            id: rightRow
            anchors.right: parent.right
            anchors.rightMargin: 12
            anchors.verticalCenter: parent.verticalCenter
            spacing: Theme.widgetGap

            Tray {}
            Mic {}
            Volume {}
            Network {}
            Bluetooth {}
            Power {
                barScreen: root.screen
            }
        }
    }

    // Left screen-edge concave: at the bottom of the bar-color column
    // on the left. Y depends on whether a left popup extends the bar.
    Shape {
        id: leftScreenCorner
        anchors.left: parent.left
        y: Theme.barHeight + (root.panelOnThisScreen && PanelState.openSide === "left" ? PanelState.openHeight : 0)
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

    // Right screen-edge concave: at the bottom of the bar-color column
    // on the right. Y depends on whether a right popup extends the bar.
    Shape {
        id: rightScreenCorner
        anchors.right: parent.right
        y: Theme.barHeight + (root.panelOnThisScreen && PanelState.openSide === "right" ? PanelState.openHeight : 0)
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

    // Concave wrap from bar into popup's inner top corner.
    // For right-side popup: sits to the left of popup, at bar bottom.
    // Fill a pillRadius square with its bottom-right corner carved out,
    // so it visually continues the bar color up to the popup while
    // curving away toward wallpaper below.
    // Concave wrap for right-side popup: same shape as bar's right
    // screen corner, positioned at popup's top-left instead.
    Shape {
        x: root.width - PanelState.openRight - Theme.pillRadius
        y: Theme.barHeight
        width: Theme.pillRadius
        height: Theme.pillRadius
        preferredRendererType: Shape.CurveRenderer
        visible: root.panelOnThisScreen && PanelState.openSide === "right"

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

    // For left-side popup: sits to the right of popup, at bar bottom.
    Shape {
        x: PanelState.openLeft
        y: Theme.barHeight
        width: Theme.pillRadius
        height: Theme.pillRadius
        preferredRendererType: Shape.CurveRenderer
        visible: root.panelOnThisScreen && PanelState.openSide === "left"

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
    }

    // Dismiss panels when clicking outside them.
    MouseArea {
        anchors.fill: parent
        enabled: PanelState.openPanel !== ""
        z: -1
        onClicked: PanelState.close()
    }
}
