pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Mpris

Singleton {
    id: root

    readonly property var players: Mpris.players?.values ?? []

    readonly property var player: {
        if (players.length === 0) return null
        for (var i = 0; i < players.length; i++) {
            if (players[i].isPlaying) return players[i]
        }
        return players[0]
    }

    readonly property bool active: player !== null
    readonly property string title: player?.trackTitle ?? ""
    readonly property string artist: player?.trackArtist ?? ""
    readonly property string art: player?.trackArtUrl ?? ""
    readonly property bool playing: !!player?.isPlaying

    function playPause() {
        if (player?.canTogglePlaying) player.togglePlaying()
    }

    function next() {
        if (player?.canGoNext) player.next()
    }

    function prev() {
        if (player?.canGoPrevious) player.previous()
    }
}
