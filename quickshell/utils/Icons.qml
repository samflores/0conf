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

    // System glyphs — Nerd Font (FontAwesome + Material Design Icons)
    readonly property var systemIcons: ({
        volume:          "\uf028",        // fa-volume-up
        volumeMid:       "\uf027",        // fa-volume-down
        volumeLow:       "\uf027",        // fa-volume-down (no separate low)
        volumeMute:      "\uf026",        // fa-volume-off
        mic:             "\uf130",        // fa-microphone
        micMute:         "\uf131",        // fa-microphone-slash
        bluetoothOn:     "\uf293",        // fa-bluetooth
        bluetoothOff:    "\uf294",        // fa-bluetooth-b
        wifiOn:          "\udb82\udd28",  // mdi-wifi-strength-4
        wifiOff:         "\udb82\udd2b",  // mdi-wifi-strength-off
        wifiLow:         "\udb82\udd1f",  // mdi-wifi-strength-1
        wifiMid:         "\udb82\udd25",  // mdi-wifi-strength-3
        wifiHigh:        "\udb82\udd28",  // mdi-wifi-strength-4
        batteryFull:     "\uf240",
        batteryThreeQ:   "\uf241",
        batteryHalf:     "\uf242",
        batteryQuarter:  "\uf243",
        batteryEmpty:    "\uf244",
        batteryCharging: "\uf0e7",        // fa-bolt
        brightness:      "\uf185",        // fa-sun
        media:           "\uf001",        // fa-music
        play:            "\uf04b",
        pause:           "\uf04c",
        prev:            "\uf048",
        next:            "\uf051",
        dndOn:           "\uf1f6",        // fa-bell-slash
        dndOff:          "\uf0f3",        // fa-bell
        tray:            "\uf00a",        // fa-th
        launcher:        "\uf002",        // fa-search
        themeDark:       "\uf186",        // fa-moon
        themeLight:      "\uf185",        // fa-sun
        notifications:   "\uf0f3",        // fa-bell
        settings:        "\uf013",        // fa-cog
        nightLight:      "\udb81\udd81",  // mdi-weather-night
        wallpaper:       "\uf03e",        // fa-picture-o
        airplaneOn:      "\uf072",        // fa-plane
        airplaneOff:     "\udb81\udd79",  // mdi-airplane-off
        perfPerformance: "\uf0e4",        // fa-tachometer (speedometer)
        perfBalanced:    "\uf24e",        // fa-balance-scale
        perfPowerSaver:  "\uf06c",        // fa-leaf
        power:           "\uf011",        // fa-power-off
        lock:            "\uf023",        // fa-lock
        suspend:         "\uf186",        // fa-moon
        reboot:          "\uf021",        // fa-refresh
        shutdown:        "\uf011",        // fa-power-off
        logout:          "\uf08b",        // fa-sign-out
        vpnOn:           "\udb80\udcbe",  // mdi-shield-lock
        vpnOff:          "\udb81\udd9f"   // mdi-web (globe)
    })
}
