import QtQuick
import QtQuick.Shapes
import "../theme"

Item {
    id: root

    property string name: ""
    property string side: "right"
    property var panelScreen: null
    default property alias contentChildren: contentItem.data
    property real contentPadding: 8

    visible: PanelState.openPanel === name && PanelState.openScreen === panelScreen

    function publishGeometry() {
        if (!visible) return
        PanelState.openHeight = height
        if (side === "right") PanelState.openRight = width
        else if (side === "left") PanelState.openLeft = width
    }

    onWidthChanged: publishGeometry()
    onHeightChanged: publishGeometry()
    onVisibleChanged: publishGeometry()

    width: contentItem.childrenRect.width + 2 * contentPadding
    height: contentItem.childrenRect.height + 2 * contentPadding

    // Anchor horizontally to parent side.
    anchors.left: root.side === "left" ? parent.left : undefined
    anchors.right: root.side === "right" ? parent.right : undefined
    anchors.horizontalCenter: root.side === "center" ? parent.horizontalCenter : undefined
    // Top of panel is flush with top of parent (which is barArea.bottom
    // in Bar.qml).
    anchors.top: parent.top

    // Main body background (flush with bar above, rounded at bottom).
    Rectangle {
        id: bg
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        color: Theme.bg
        // The convex-rounded corner (meets wallpaper directly): for a
        // right-side popup this is bottom-left; for a left-side popup
        // it's bottom-right. The other bottom corner is concave and
        // drawn by bar.qml's corner area.
        bottomLeftRadius: root.side === "right" ? Theme.pillRadius : 0
        bottomRightRadius: root.side === "left" ? Theme.pillRadius : 0
    }

    // Concave wrap where bar continues past the popup's inner edge.
    // Only applicable to left/right panels, on the inner side.

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
