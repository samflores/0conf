import QtQuick
import "../../theme"

Text {
    id: root

    required property var niri

    readonly property string rawTitle: root.niri.focusedWindow?.title ?? ""

    text: rawTitle.length > 60 ? rawTitle.substring(0, 57) + "…" : rawTitle
    color: Theme.fg
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontSize
    elide: Text.ElideRight
    visible: text.length > 0
}
