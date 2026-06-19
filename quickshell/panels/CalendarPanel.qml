import QtQuick
import QtQuick.Layouts
import Quickshell
import "../theme"
import "../services"

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

        // Events section
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 8

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Text {
                    text: "UPCOMING"
                    color: Theme.fgDim
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize - 1
                    font.bold: true
                    Layout.fillWidth: true
                }
                Text {
                    visible: GoogleCalendar.lastRefresh.getTime() > 0
                    text: {
                        var d = GoogleCalendar.lastRefresh
                        var h = d.getHours(), m = d.getMinutes()
                        return "synced " + (h < 10 ? "0" + h : h) + ":" + (m < 10 ? "0" + m : m)
                    }
                    color: Theme.fgDim
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize - 1
                }
                MouseArea {
                    implicitWidth: refreshIcon.implicitWidth + 8
                    implicitHeight: refreshIcon.implicitHeight + 4
                    cursorShape: Qt.PointingHandCursor
                    onClicked: GoogleCalendar.refresh()
                    Text {
                        id: refreshIcon
                        anchors.centerIn: parent
                        text: GoogleCalendar.refreshing ? "" : ""  // spinner / refresh
                        color: Theme.fgDim
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSize
                    }
                }
            }

            // Empty state
            Text {
                visible: !GoogleCalendar.accounts || GoogleCalendar.accounts.length === 0
                text: "No calendar accounts configured.\nSet up accounts in ~/.config/0conf/gcal/settings.json"
                color: Theme.fgDim
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize - 1
            }
            Text {
                visible: GoogleCalendar.accounts.length > 0 && GoogleCalendar.events.length === 0
                text: "No upcoming events."
                color: Theme.fgDim
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize - 1
            }
            Text {
                Layout.fillWidth: true
                visible: GoogleCalendar.lastError.length > 0
                text: GoogleCalendar.lastError
                color: Theme.fgDim
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize - 2
                wrapMode: Text.WordWrap
            }

            Repeater {
                model: GoogleCalendar.events.slice(0, 12)

                MouseArea {
                    Layout.fillWidth: true
                    implicitHeight: eventRow.implicitHeight
                    cursorShape: modelData.url ? Qt.PointingHandCursor : Qt.ArrowCursor
                    onClicked: GoogleCalendar.openUrl(modelData.url)
                    opacity: {
                        var nowMs = root.now.getTime()
                        if (modelData.end.getTime() < nowMs) return 0.4
                        // In-progress OR starts today = fully bright.
                        if (modelData.start.getTime() <= nowMs) return 1.0
                        return root.isSameDay(modelData.start, root.now) ? 1.0 : 0.7
                    }

                    RowLayout {
                        id: eventRow
                        anchors.left: parent.left
                        anchors.right: parent.right
                        spacing: 10

                        Rectangle {
                            width: 3
                            Layout.preferredHeight: eventTitle.implicitHeight + eventMeta.implicitHeight + 4
                            radius: 1.5
                            color: modelData.color && modelData.color.length > 0 ? modelData.color : Theme.accent
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 0

                            Text {
                                id: eventTitle
                                Layout.fillWidth: true
                                text: modelData.title || "(untitled)"
                                color: Theme.fg
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontSize
                                elide: Text.ElideRight
                            }
                            Text {
                                id: eventMeta
                                Layout.fillWidth: true
                                text: {
                                    var s = modelData.start
                                    var e = modelData.end
                                    function pad(n) { return n < 10 ? "0" + n : "" + n }
                                    function fmt(d) { return pad(d.getHours()) + ":" + pad(d.getMinutes()) }
                                    var sameDay = s.getFullYear() === root.now.getFullYear()
                                                && s.getMonth() === root.now.getMonth()
                                                && s.getDate() === root.now.getDate()
                                    var dateLabel = sameDay ? "Today"
                                                  : Qt.formatDate(s, "ddd MMM d")
                                    var timeLabel = modelData.allDay ? "all day"
                                                  : (fmt(s) + "–" + fmt(e))
                                    var bits = [dateLabel, timeLabel]
                                    if (modelData.label) bits.push(modelData.label)
                                    if (modelData.location) bits.push(modelData.location)
                                    return bits.join(" · ")
                                }
                                color: Theme.fgDim
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontSize - 1
                                elide: Text.ElideRight
                            }
                        }

                        MouseArea {
                            visible: modelData.meetUrl && modelData.meetUrl.length > 0
                            implicitWidth: meetIcon.implicitWidth + 12
                            implicitHeight: meetIcon.implicitHeight + 8
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true
                            onClicked: GoogleCalendar.openUrl(modelData.meetUrl)

                            Rectangle {
                                anchors.fill: parent
                                radius: 4
                                color: parent.containsMouse ? Theme.surface : "transparent"
                            }
                            Text {
                                id: meetIcon
                                anchors.centerIn: parent
                                text: ""  // fa-video-camera
                                color: Theme.accent
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontSize
                            }
                        }
                    }
                }
            }
        }

        // Calendar picker (collapsible)
        ColumnLayout {
            id: picker
            Layout.fillWidth: true
            spacing: 6

            property bool expanded: false

            MouseArea {
                Layout.fillWidth: true
                implicitHeight: pickerHeader.implicitHeight + 4
                cursorShape: Qt.PointingHandCursor
                onClicked: picker.expanded = !picker.expanded

                RowLayout {
                    id: pickerHeader
                    anchors.fill: parent
                    spacing: 6
                    Text {
                        text: picker.expanded ? "" : ""  // chevron-down / chevron-right
                        color: Theme.fgDim
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSize - 2
                    }
                    Text {
                        text: "CALENDARS"
                        color: Theme.fgDim
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSize - 1
                        font.bold: true
                        Layout.fillWidth: true
                    }
                }
            }

            Repeater {
                model: picker.expanded ? GoogleCalendar.accounts : []

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2

                    property int accountIndex: index
                    property var accountData: modelData

                    Text {
                        text: accountData.label || accountData.alias
                        color: Theme.fg
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSize - 1
                        font.bold: true
                        topPadding: 4
                    }

                    Repeater {
                        model: GoogleCalendar.calendarsByAccount[accountData.alias] || []

                        MouseArea {
                            Layout.fillWidth: true
                            id: calRow_ma
                            implicitHeight: calRow.implicitHeight + 4
                            cursorShape: Qt.PointingHandCursor
                            property bool selected: {
                                var cals = accountData.calendars || []
                                // Empty selection = show all
                                if (cals.length === 0) return true
                                return cals.indexOf(modelData.title) >= 0
                            }
                            property bool allMode: (accountData.calendars || []).length === 0

                            onClicked: {
                                // If we're in "all mode", first click materializes
                                // the full list minus the clicked one.
                                if (allMode) {
                                    var all = GoogleCalendar.calendarsByAccount[accountData.alias] || []
                                    var next = []
                                    for (var i = 0; i < all.length; i++) {
                                        if (all[i].title !== modelData.title) next.push(all[i].title)
                                    }
                                    var accs = GoogleCalendar.accounts.slice()
                                    var acc = Object.assign({}, accs[accountIndex])
                                    acc.calendars = next
                                    accs[accountIndex] = acc
                                    GoogleCalendar.accounts = accs
                                    GoogleCalendar.saveSettings()
                                    GoogleCalendar.refresh()
                                } else {
                                    GoogleCalendar.toggleCalendar(accountIndex, modelData.title)
                                }
                            }

                            RowLayout {
                                id: calRow
                                anchors.fill: parent
                                spacing: 8

                                Text {
                                    // Filled square if selected, empty square otherwise.
                                    text: calRow_ma.selected ? "" : ""
                                    color: calRow_ma.selected ? Theme.accent : Theme.fgDim
                                    font.family: Theme.fontFamily
                                    font.pixelSize: Theme.fontSize - 1
                                }
                                Text {
                                    text: modelData.title
                                    color: Theme.fg
                                    font.family: Theme.fontFamily
                                    font.pixelSize: Theme.fontSize - 1
                                    Layout.fillWidth: true
                                    elide: Text.ElideRight
                                }
                                Text {
                                    text: modelData.access
                                    color: Theme.fgDim
                                    font.family: Theme.fontFamily
                                    font.pixelSize: Theme.fontSize - 2
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
