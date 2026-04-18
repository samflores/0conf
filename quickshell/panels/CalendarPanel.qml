import QtQuick
import QtQuick.Layouts
import Quickshell
import "../theme"

Panel {
    id: root

    name: "calendar"
    side: "center"
    contentPadding: 16

    // A ticking clock for the analog + digital rows.
    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    property date now: clock.date

    // Offsets in hours from UTC. Updated 2026-04-18; DST varies.
    readonly property var zones: [
        { label: "Miami",       offsetHours: -4 },   // EDT
        { label: "Los Angeles", offsetHours: -7 },   // PDT
        { label: "São Paulo",   offsetHours: -3 }    // BRT (no DST)
    ]

    // View-month: initially the current month; prev/next navigate.
    property int viewYear: now.getFullYear()
    property int viewMonth: now.getMonth()

    function shiftMonth(delta) {
        var d = new Date(viewYear, viewMonth + delta, 1)
        viewYear = d.getFullYear()
        viewMonth = d.getMonth()
    }

    function isSameDay(a, b) {
        return a.getFullYear() === b.getFullYear()
            && a.getMonth() === b.getMonth()
            && a.getDate() === b.getDate()
    }

    // Format time at an offset (in hours) from UTC as HH:mm.
    function formatAtOffset(date, offsetHours) {
        var utcMs = date.getTime() + date.getTimezoneOffset() * 60000
        var zoned = new Date(utcMs + offsetHours * 3600000)
        var h = zoned.getHours()
        var m = zoned.getMinutes()
        return (h < 10 ? "0" + h : h) + ":" + (m < 10 ? "0" + m : m)
    }

    ColumnLayout {
        spacing: 14

        // Today card — spans both columns at the top.
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: cardRow.implicitHeight + 24
            radius: 10
            color: Theme.surface

            RowLayout {
                id: cardRow
                anchors.centerIn: parent
                spacing: 10

                Text {
                    text: root.now.getDate()
                    color: Theme.fg
                    font.family: Theme.fontFamily
                    font.pixelSize: 36
                    font.bold: true
                }
                ColumnLayout {
                    spacing: 0
                    Layout.alignment: Qt.AlignLeft

                    RowLayout {
                        spacing: 6
                        Text {
                            text: Qt.formatDate(root.now, "MMMM").toUpperCase()
                            color: Theme.fg
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSize + 4
                            font.bold: true
                        }
                        Text {
                            text: root.now.getFullYear()
                            color: Theme.fgDim
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSize + 2
                            Layout.alignment: Qt.AlignBottom
                            bottomPadding: 2
                        }
                    }
                    Text {
                        text: Qt.formatDate(root.now, "dddd")
                        color: Theme.fgDim
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSize
                    }
                }
            }
        }

        RowLayout {
            spacing: 20

            // Left column: date header + calendar grid
            ColumnLayout {
            spacing: 12
            Layout.alignment: Qt.AlignTop

            // Header row: month/year label + prev/next
            RowLayout {
                spacing: 8
                Layout.fillWidth: true

                Text {
                    text: Qt.formatDate(new Date(root.viewYear, root.viewMonth, 1), "MMMM yyyy")
                    color: Theme.fg
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize + 2
                    font.bold: true
                    Layout.fillWidth: true
                }
                MouseArea {
                    implicitWidth: prev.implicitWidth + 8
                    implicitHeight: prev.implicitHeight + 4
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.shiftMonth(-1)
                    Text {
                        id: prev
                        anchors.centerIn: parent
                        text: "\uf053"  // fa-chevron-left
                        color: Theme.fgDim
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSize
                    }
                }
                MouseArea {
                    implicitWidth: next.implicitWidth + 8
                    implicitHeight: next.implicitHeight + 4
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.shiftMonth(1)
                    Text {
                        id: next
                        anchors.centerIn: parent
                        text: "\uf054"  // fa-chevron-right
                        color: Theme.fgDim
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSize
                    }
                }
            }

            // Month grid
            Grid {
                columns: 7
                columnSpacing: 6
                rowSpacing: 4

                // Weekday headers
                Repeater {
                    model: ["S", "M", "T", "W", "T", "F", "S"]
                    Text {
                        width: 28
                        horizontalAlignment: Text.AlignHCenter
                        text: modelData
                        color: Theme.fgDim
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSize - 1
                    }
                }

                Repeater {
                    model: 42  // 6 weeks × 7 days
                    Text {
                        property date cellDate: {
                            // First cell aligns to Sunday on or before day 1.
                            var first = new Date(root.viewYear, root.viewMonth, 1)
                            var startOffset = first.getDay()  // 0..6 (Sun=0)
                            var d = new Date(root.viewYear, root.viewMonth, 1 - startOffset + index)
                            return d
                        }
                        property bool inMonth: cellDate.getMonth() === root.viewMonth
                        property bool isToday: root.isSameDay(cellDate, root.now)

                        width: 28
                        horizontalAlignment: Text.AlignHCenter
                        text: cellDate.getDate()
                        color: isToday ? Theme.accent : (inMonth ? Theme.fg : Theme.fgDim)
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSize
                        font.bold: isToday
                    }
                }
            }
        }

        // Right column: analog clock + 3 digital clocks
        ColumnLayout {
            spacing: 12
            Layout.alignment: Qt.AlignTop

            // Analog clock
            Item {
                id: clockFace
                implicitWidth: 96
                implicitHeight: 96
                Layout.alignment: Qt.AlignHCenter

                // Hour ticks: triangles at 12/3/6/9, small marks elsewhere.
                Repeater {
                    model: 12
                    Item {
                        // Cardinal hours (0/3/6/9) get a triangle pointing in.
                        readonly property bool cardinal: index % 3 === 0

                        width: cardinal ? 8 : 2
                        height: cardinal ? 8 : 4
                        x: clockFace.width / 2 - width / 2
                        y: 2
                        transform: Rotation {
                            origin.x: width / 2
                            origin.y: clockFace.height / 2 - 2
                            angle: index * 30
                        }

                        // Simple tick for non-cardinal hours.
                        Rectangle {
                            visible: !parent.cardinal
                            anchors.fill: parent
                            radius: 1
                            color: Theme.fgDim
                        }

                        // Triangle pointing toward the center (downward in
                        // this local frame) for cardinal hours.
                        Canvas {
                            visible: parent.cardinal
                            anchors.fill: parent
                            onPaint: {
                                var ctx = getContext("2d")
                                ctx.reset()
                                ctx.fillStyle = Theme.fg
                                ctx.beginPath()
                                ctx.moveTo(0, 0)
                                ctx.lineTo(width, 0)
                                ctx.lineTo(width / 2, height)
                                ctx.closePath()
                                ctx.fill()
                            }
                            Component.onCompleted: requestPaint()
                        }
                    }
                }

                // Hour hand: length 28% of face, 3px wide, tail at face center.
                Rectangle {
                    width: 3
                    height: clockFace.width * 0.28
                    radius: 1.5
                    color: Theme.fg
                    x: clockFace.width / 2 - width / 2
                    y: clockFace.height / 2 - height
                    transform: Rotation {
                        origin.x: 1.5
                        origin.y: clockFace.width * 0.28
                        angle: (root.now.getHours() % 12) * 30 + root.now.getMinutes() * 0.5
                    }
                }

                // Minute hand: length 38%, 2px wide.
                Rectangle {
                    width: 2
                    height: clockFace.width * 0.38
                    radius: 1
                    color: Theme.fg
                    x: clockFace.width / 2 - width / 2
                    y: clockFace.height / 2 - height
                    transform: Rotation {
                        origin.x: 1
                        origin.y: clockFace.width * 0.38
                        angle: root.now.getMinutes() * 6
                    }
                }

                // Second hand: length 44%, 1px wide.
                Rectangle {
                    width: 1
                    height: clockFace.width * 0.44
                    color: Theme.accent
                    x: clockFace.width / 2 - width / 2
                    y: clockFace.height / 2 - height
                    transform: Rotation {
                        origin.x: 0.5
                        origin.y: clockFace.width * 0.44
                        angle: root.now.getSeconds() * 6
                    }
                }

                // Center pivot
                Rectangle {
                    anchors.centerIn: parent
                    width: 5
                    height: 5
                    radius: 2.5
                    color: Theme.accent
                }
            }

            // Digital clocks for configured timezones
            Repeater {
                model: root.zones

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    Text {
                        text: modelData.label
                        color: Theme.fgDim
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSize
                        Layout.preferredWidth: 80
                    }
                    Text {
                        text: root.formatAtOffset(root.now, modelData.offsetHours)
                        color: Theme.fg
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSize
                    }
                }
            }
        }
        }
    }
}
