import QtQuick
import QtQuick.Shapes
import "../theme"

Item {
    id: root

    property string name: ""
    // "left" (touches left edge), "right" (touches right edge), "center"
    property string side: "right"
    property var panelScreen: null
    default property alias contentChildren: contentItem.data
    property real contentPadding: 8

    readonly property bool touchesLeftEdge: side === "left"
    readonly property bool touchesRightEdge: side === "right"

    readonly property bool open: PanelState.openPanel === name && PanelState.openScreen === panelScreen

    // Stretch animation: content height grows from 0 with a bounce at
    // the bottom while the top stays flush with the bar.
    property bool animating: false
    visible: open || animating

    property real targetHeight: contentItem.childrenRect.height + 2 * contentPadding
    property real stretchHeight: open ? targetHeight : 0

    Behavior on stretchHeight {
        NumberAnimation {
            duration: 360
            easing.type: Easing.OutElastic
            easing.amplitude: 1.0
            easing.period: 0.4
        }
        enabled: root.visible
    }

    // Horizontal squish: when the popup overshoots its target height,
    // squeeze the body inward so it looks like gelatin stretching. The
    // scale origin is the top-center so the bar-connection stays fixed.
    readonly property real overshoot: Math.max(0, (stretchHeight - targetHeight) / targetHeight)
    readonly property real xSquish: Math.max(0.85, 1 - overshoot * 1.5)

    transform: Scale {
        // Anchor squish to the edge the popup touches so that edge
        // stays glued; center popups squish around their center.
        origin.x: root.touchesRightEdge ? root.width
                 : root.touchesLeftEdge ? 0
                 : root.width / 2
        origin.y: 0
        xScale: root.xSquish
    }

    onStretchHeightChanged: {
        if (!open && stretchHeight <= 0.5) {
            animating = false
        } else if (open) {
            animating = true
        }
    }

    onOpenChanged: {
        if (open) animating = true
    }

    function publishGeometry() {
        if (!visible) return
        PanelState.openHeight = height
        PanelState.openLeft = touchesLeftEdge ? 0 : x
        PanelState.openRight = touchesRightEdge ? 0 : (parent.width - (x + width))
        PanelState.openWidth = width
    }

    onWidthChanged: publishGeometry()
    onHeightChanged: publishGeometry()
    onVisibleChanged: publishGeometry()
    onXChanged: publishGeometry()

    width: contentItem.childrenRect.width + 2 * contentPadding
    height: stretchHeight

    anchors.left: touchesLeftEdge ? parent.left : undefined
    anchors.right: touchesRightEdge ? parent.right : undefined
    anchors.horizontalCenter: side === "center" ? parent.horizontalCenter : undefined
    anchors.top: parent.top

    Item {
        id: body
        anchors.fill: parent
        clip: true

        Rectangle {
            id: bg
            anchors.fill: parent
            color: Theme.bg
            bottomLeftRadius: root.touchesLeftEdge ? 0 : Theme.pillRadius
            bottomRightRadius: root.touchesRightEdge ? 0 : Theme.pillRadius
        }

        Item {
            id: contentItem
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: root.contentPadding
            anchors.topMargin: root.contentPadding
            width: childrenRect.width
            height: childrenRect.height
        }
    }

    // Concave wrap at popup's top-LEFT (for right-touching or centered
    // popups). Drawn here so it transforms with Panel's Scale and stays
    // glued to the popup's inner edge as it squishes.
    Shape {
        x: -Theme.pillRadius
        y: 0
        width: Theme.pillRadius
        height: Theme.pillRadius
        preferredRendererType: Shape.CurveRenderer
        visible: !root.touchesLeftEdge

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

    // Concave wrap at popup's top-RIGHT (for left-touching or centered).
    Shape {
        x: root.width
        y: 0
        width: Theme.pillRadius
        height: Theme.pillRadius
        preferredRendererType: Shape.CurveRenderer
        visible: !root.touchesRightEdge

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
}
