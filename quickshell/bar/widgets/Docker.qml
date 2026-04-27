import QtQuick
import QtQuick.Layouts
import "../../theme"
import "../../panels"
import "../../services"

MouseArea {
    id: root

    required property var barScreen

    visible: Docker.available
    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight
    cursorShape: Qt.PointingHandCursor
    hoverEnabled: true

    onClicked: PanelState.toggle("docker", "right", root.barScreen)

    RowLayout {
        id: row
        spacing: 4

        Text {
            text: ""  // nf-linux-docker
            color: PanelState.openPanel === "docker" ? Theme.accent : Theme.fg
            font.family: Theme.fontFamily
            font.pixelSize: Theme.iconSize
        }

        Text {
            text: Docker.containers.length + (Docker.containers.length === 1 ? " container" : " containers")
            visible: root.containsMouse
            color: Theme.fg
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
        }
    }
}
