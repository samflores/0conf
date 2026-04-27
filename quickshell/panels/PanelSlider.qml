import QtQuick
import "../theme"

// Drop-in slider used inside panels. QtQuick.Controls.Slider doesn't
// handle drag reliably on a layer-shell PanelWindow surface, so we drive
// the position from a MouseArea directly.
Item {
    id: root

    property real from: 0
    property real to: 100
    property real value: 0
    property bool enabled: true
    signal moved(real value)

    implicitWidth: 220
    implicitHeight: 16

    readonly property real _span: Math.max(0.0001, root.to - root.from)
    readonly property real _ratio: Math.max(0, Math.min(1, (root.value - root.from) / root._span))

    function _valueFromX(x) {
        var w = Math.max(1, hit.width - handle.width)
        var px = Math.max(0, Math.min(w, x - handle.width / 2))
        return root.from + (px / w) * root._span
    }

    function _commit(x) {
        if (!root.enabled) return
        var v = root._valueFromX(x)
        if (v !== root.value) {
            root.value = v
            root.moved(v)
        }
    }

    Rectangle {
        id: track
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        height: 4
        radius: 2
        color: Theme.surface
        opacity: root.enabled ? 1 : 0.5

        Rectangle {
            width: root._ratio * parent.width
            height: parent.height
            radius: 2
            color: Theme.accent
        }
    }

    Rectangle {
        id: handle
        width: 12
        height: 12
        radius: 6
        color: Theme.fg
        border.color: Theme.accent
        border.width: 1
        opacity: root.enabled ? 1 : 0.5
        anchors.verticalCenter: parent.verticalCenter
        x: root._ratio * (root.width - width)
    }

    MouseArea {
        id: hit
        anchors.fill: parent
        enabled: root.enabled
        hoverEnabled: true
        cursorShape: root.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor

        onPressed: function(m) { root._commit(m.x) }
        onPositionChanged: function(m) {
            if (m.buttons & Qt.LeftButton) root._commit(m.x)
        }
        onWheel: function(wheel) {
            if (!root.enabled) return
            var step = root._span / 20  // 5% per notch
            var dir = wheel.angleDelta.y > 0 ? 1 : -1
            var v = Math.max(root.from, Math.min(root.to, root.value + dir * step))
            if (v !== root.value) {
                root.value = v
                root.moved(v)
            }
            wheel.accepted = true
        }
    }
}
