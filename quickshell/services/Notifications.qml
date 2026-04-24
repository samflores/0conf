pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications

Singleton {
    id: root

    property var items: []
    property int focusIndex: -1
    property bool layerFocused: false

    readonly property var focused: (focusIndex >= 0 && focusIndex < items.length) ? items[focusIndex] : null

    function focusLayer() {
        if (items.length === 0) return
        if (focusIndex < 0) focusIndex = 0
        layerFocused = true
    }

    function releaseFocus() {
        layerFocused = false
        focusIndex = -1
    }

    function focusNext() {
        if (items.length === 0) return
        focusIndex = (focusIndex + 1) % items.length
    }

    function focusPrev() {
        if (items.length === 0) return
        focusIndex = (focusIndex - 1 + items.length) % items.length
    }

    function dismissFocused() {
        if (!focused) return
        var idx = focusIndex
        focused.dismiss()
        if (items.length === 0) {
            releaseFocus()
        } else {
            focusIndex = Math.min(idx, items.length - 1)
        }
    }

    function dismissAll() {
        var copy = items.slice()
        for (var i = 0; i < copy.length; i++) copy[i].dismiss()
        releaseFocus()
    }

    function invokeAction(index) {
        if (!focused || !focused.actions) return
        var acts = focused.actions
        if (index < 0 || index >= acts.length) return
        acts[index].invoke()
    }

    function _rebuild() {
        var src = server.trackedNotifications?.values ?? []
        var list = []
        for (var i = 0; i < src.length; i++) list.push(src[i])
        items = list
        if (focusIndex >= items.length) focusIndex = items.length - 1
        if (items.length === 0) releaseFocus()
    }

    NotificationServer {
        id: server
        keepOnReload: false
        bodySupported: true
        bodyMarkupSupported: true
        actionsSupported: true
        imageSupported: true
        persistenceSupported: false

        onNotification: function(notif) {
            notif.tracked = true
        }
    }

    Connections {
        target: server.trackedNotifications
        function onValuesChanged() { root._rebuild() }
    }

    Component.onCompleted: _rebuild()

    IpcHandler {
        target: "notifications"

        function focus() { root.focusLayer() }
        function release() { root.releaseFocus() }
        function next() { root.focusNext() }
        function prev() { root.focusPrev() }
        function dismiss() { root.dismissFocused() }
        function dismissAll() { root.dismissAll() }
    }
}
