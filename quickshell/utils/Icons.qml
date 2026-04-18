pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    // WTTR weather codes → Nerd Font weather glyphs (nf-weather-*)
    readonly property var weatherIcons: ({
        "113": "\uf185",   // day-sunny
        "116": "\uf002",   // day-cloudy
        "119": "\uf013",   // cloudy
        "122": "\uf013",   // cloudy
        "143": "\uf014",   // fog
        "176": "\uf019",   // rain
        "179": "\uf01b",   // snow
        "182": "\uf0b2",   // rain-mix
        "185": "\uf0b2",
        "200": "\uf01e",   // thunderstorm
        "227": "\uf064",   // snow-wind
        "230": "\uf064",
        "248": "\uf014",
        "260": "\uf014",
        "263": "\uf019",
        "266": "\uf019",
        "281": "\uf0b2",
        "284": "\uf0b2",
        "293": "\uf019",
        "296": "\uf019",
        "299": "\uf019",
        "302": "\uf01a",   // hail → showers (use showers glyph)
        "305": "\uf019",
        "308": "\uf01a",
        "311": "\uf0b2",
        "314": "\uf0b2",
        "317": "\uf0b2",
        "320": "\uf064",
        "323": "\uf01b",
        "326": "\uf01b",
        "329": "\uf064",
        "332": "\uf064",
        "335": "\uf01b",
        "338": "\uf064",
        "350": "\uf01a",
        "353": "\uf019",
        "356": "\uf019",
        "359": "\uf01a",
        "362": "\uf019",
        "365": "\uf019",
        "368": "\uf064",
        "371": "\uf01b",
        "374": "\uf01a",
        "377": "\uf01a",
        "386": "\uf01e",
        "389": "\uf01e",
        "392": "\uf01e",
        "395": "\uf01b"
    })

    // Desktop category → Nerd Font glyph (nf-md-*, nf-fa-*)
    readonly property var categoryIcons: ({
        WebBrowser:  "\udb80\udf43",   // globe
        Printing:    "\uf02f",         // print
        Security:    "\udb80\udcbe",   // shield-lock
        Network:     "\uf0e8",         // sitemap
        Archiving:   "\uf187",         // archive
        Compression: "\uf187",
        Development: "\uf121",         // code
        IDE:         "\uf121",
        Building:    "\uf085",         // cogs
        Debugger:    "\uf188",         // bug
        GUIDesigner: "\udb81\ude03",   // pencil-ruler
        Translation: "\udb80\udfd8",   // translate
        Game:        "\uf11b",         // gamepad
        Graphics:    "\udb80\udc6e",   // palette
        Audio:       "\uf001",         // music
        Video:       "\uf03d",         // video
        AudioVideo:  "\uf008",         // film
        Office:      "\uf0f6",         // file-text
        Email:       "\uf0e0",         // envelope
        Education:   "\uf19d",         // graduation-cap
        Science:     "\udb80\udc52",   // flask
        Utility:     "\uf013",         // cog
        System:      "\uf108",         // desktop
        Settings:    "\uf013",
        TerminalEmulator: "\uf120",    // terminal
        FileManager: "\uf07b",         // folder
        Chat:        "\uf075",         // comment
        VideoConference: "\uf03d"
    })

    // System glyphs used by bar, panels, and OSDs
    readonly property var systemIcons: ({
        volume:          "\udb81\udd7e",  // volume-high
        volumeMid:       "\udb81\udd80",  // volume-medium
        volumeLow:       "\udb81\udd7f",  // volume-low
        volumeMute:      "\udb81\udd81",  // volume-mute
        mic:             "\uf130",        // microphone
        micMute:         "\uf131",        // microphone-slash
        bluetoothOn:     "\uf293",        // bluetooth
        bluetoothOff:    "\uf294",        // bluetooth-b (used as off)
        wifiOn:          "\uf1eb",        // wifi
        wifiOff:         "\uf6ab",        // wifi-off (mdi fallback)
        wifiLow:         "\udb82\udd7a",  // wifi-strength-1
        wifiMid:         "\udb82\udd7c",  // wifi-strength-3
        wifiHigh:        "\udb82\udd7e",  // wifi-strength-4
        batteryFull:     "\uf240",
        batteryThreeQ:   "\uf241",
        batteryHalf:     "\uf242",
        batteryQuarter:  "\uf243",
        batteryEmpty:    "\uf244",
        batteryCharging: "\uf0e7",        // bolt
        brightness:      "\uf185",        // sun
        media:           "\uf001",        // music
        play:            "\uf04b",
        pause:           "\uf04c",
        prev:            "\uf048",
        next:            "\uf051",
        dndOn:           "\uf05e",        // ban
        dndOff:          "\uf0a2",        // bell
        tray:            "\udb80\udd82",  // apps
        launcher:        "\uf0c9",        // bars
        themeDark:       "\uf186",        // moon
        themeLight:      "\uf185",        // sun
        notifications:   "\uf0a2",        // bell
        settings:        "\uf013"         // cog
    })
}
