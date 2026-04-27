import QtQuick
import QtQuick.Layouts
import "../../theme"
import "../../services"

MouseArea {
    id: root

    visible: Recorder.recording
    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight
    cursorShape: Qt.PointingHandCursor
    hoverEnabled: true

    onClicked: Recorder.stop()

    RowLayout {
        id: row
        spacing: 4

        Text {
            id: dot
            text: ""  // nf-fa-circle
            color: Theme.err
            font.family: Theme.fontFamily
            font.pixelSize: Theme.iconSize

            SequentialAnimation on opacity {
                running: root.visible
                loops: Animation.Infinite
                NumberAnimation { from: 1.0; to: 0.3; duration: 700; easing.type: Easing.InOutSine }
                NumberAnimation { from: 0.3; to: 1.0; duration: 700; easing.type: Easing.InOutSine }
            }
        }

        Text {
            text: "rec"
            visible: root.containsMouse
            color: Theme.fg
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
        }
    }
}
