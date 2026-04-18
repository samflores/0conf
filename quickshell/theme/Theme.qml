pragma Singleton

import QtQuick
import Quickshell
import "."

Singleton {
    id: root

    readonly property bool dark: ThemeState.dark

    readonly property color bg:      dark ? "#0E1415" : "#F7F7F7"
    readonly property color bgAlt:   dark ? "#1A1F20" : "#F0F0F0"
    readonly property color surface: dark ? "#293334" : "#E0E0E0"
    readonly property color fg:      dark ? "#CECECE" : "#000000"
    readonly property color fgDim:   dark ? "#708B8D" : "#777777"
    readonly property color accent:  dark ? "#71ADE7" : "#325CC0"
    readonly property color ok:      dark ? "#95CB82" : "#448C27"
    readonly property color warn:    dark ? "#CD974B" : "#FFBC5D"
    readonly property color err:     dark ? "#CC3333" : "#AA3731"
    readonly property color border:  dark ? "#1A1F20" : "#E0E0E0"

    readonly property int barHeight:   28
    readonly property int pillRadius:  10
    readonly property int pillPadding: 8
    readonly property int widgetGap:   6
    readonly property int outerMargin: 8

    readonly property string fontFamily: "MonaspiceAr Nerd Font Mono"
    readonly property int fontSize: 12
    readonly property int iconSize: 14
}
