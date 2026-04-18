pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    id: root

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property PwNode source: Pipewire.defaultAudioSource

    readonly property bool muted: !!sink?.audio?.muted
    readonly property int volume: Math.round((sink?.audio?.volume ?? 0) * 100)

    readonly property bool micMuted: !!source?.audio?.muted
    readonly property int micVolume: Math.round((source?.audio?.volume ?? 0) * 100)

    function setVolume(percent: int): void {
        if (sink?.ready && sink?.audio) {
            sink.audio.muted = false
            sink.audio.volume = Math.max(0, Math.min(100, percent)) / 100
        }
    }

    function setMuted(m: bool): void {
        if (sink?.ready && sink?.audio) sink.audio.muted = m
    }

    function toggleMute(): void { setMuted(!muted) }

    function setMicVolume(percent: int): void {
        if (source?.ready && source?.audio) {
            source.audio.muted = false
            source.audio.volume = Math.max(0, Math.min(100, percent)) / 100
        }
    }

    function setMicMuted(m: bool): void {
        if (source?.ready && source?.audio) source.audio.muted = m
    }

    function toggleMicMute(): void { setMicMuted(!micMuted) }

    PwObjectTracker {
        objects: [root.sink, root.source].filter(n => n !== null)
    }
}
