import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import Quickshell
import Niri 0.1
import "../theme"

PanelWindow {
    id: root

    required property var modelData
    screen: modelData

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: Theme.barHeight + Theme.pillRadius
    exclusiveZone: Theme.barHeight
    color: "transparent"

    Niri {
        id: niri
        Component.onCompleted: connect()
        onErrorOccurred: function(error) { console.error("Niri error:", error) }
    }

    Rectangle {
        id: barBg
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: Theme.barHeight
        color: Theme.bg
    }

    RowLayout {
        id: leftRow
        anchors.left: parent.left
        anchors.leftMargin: 12
        anchors.verticalCenter: barBg.verticalCenter
        spacing: Theme.widgetGap

        Text {
            text: "·"
            color: Theme.fgDim
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
        }
    }

    RowLayout {
        id: centerRow
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: barBg.verticalCenter
        spacing: Theme.widgetGap

        Text {
            text: "·"
            color: Theme.fgDim
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
        }
    }

    RowLayout {
        id: rightRow
        anchors.right: parent.right
        anchors.rightMargin: 12
        anchors.verticalCenter: barBg.verticalCenter
        spacing: Theme.widgetGap

        Text {
            text: "·"
            color: Theme.fgDim
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
        }
    }

    // Concave bottom corners: squares flush with the screen edge,
    // filled with bar color, with a counterclockwise arc cutting
    // back into the bar so the bar appears to curve inward where
    // it meets the wallpaper.
    Shape {
        id: leftCorner
        anchors.left: parent.left
        anchors.top: barBg.bottom
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

    Shape {
        id: rightCorner
        anchors.right: parent.right
        anchors.top: barBg.bottom
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
}
