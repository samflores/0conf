import QtQuick
import QtQuick.Layouts
import "../theme"
import "../services"

Panel {
    id: root

    name: "vpn"
    side: "right"
    contentPadding: 12

    // "list" → connection list, "auth" → openvpn credentials.
    property string view: "list"

    property string formUser: Vpn.openvpnUser
    property string formPassword: ""
    property string formOtp: ""

    onOpenChanged: {
        if (open) {
            view = "list"
            formUser = Vpn.openvpnUser
            formPassword = ""
            formOtp = ""
        }
    }

    // ----- Reusable bits ----------------------------------------------------

    component Field: Rectangle {
        id: f
        property alias text: input.text
        property alias placeholder: ph.text
        property bool secret: false
        property bool autoFocus: false
        signal submit()

        Layout.fillWidth: true
        Layout.minimumWidth: 240
        implicitHeight: 24
        radius: 6
        color: Theme.bgAlt
        border.color: input.activeFocus ? Theme.accent : "transparent"
        border.width: 1

        Text {
            id: ph
            anchors.left: parent.left
            anchors.leftMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            color: Theme.fgDim
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
            visible: input.text === ""
        }

        TextInput {
            id: input
            anchors.fill: parent
            anchors.leftMargin: 8
            anchors.rightMargin: 8
            verticalAlignment: TextInput.AlignVCenter
            color: Theme.fg
            selectionColor: Theme.accent
            selectedTextColor: Theme.bg
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
            echoMode: f.secret ? TextInput.Password : TextInput.Normal
            clip: true
            activeFocusOnTab: true
            onAccepted: f.submit()
            Component.onCompleted: { if (f.autoFocus) input.forceActiveFocus() }
        }
    }

    component PrimaryButton: MouseArea {
        id: b
        property string label
        property bool enabled: true
        signal triggered()

        Layout.fillWidth: true
        implicitHeight: 26
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        hoverEnabled: true
        onClicked: { if (b.enabled) b.triggered() }

        Rectangle {
            anchors.fill: parent
            radius: 6
            color: !b.enabled ? Theme.bgAlt
                  : b.containsMouse ? Theme.accent : Theme.surface
        }
        Text {
            anchors.centerIn: parent
            text: b.label
            color: !b.enabled ? Theme.fgDim
                  : b.containsMouse ? Theme.bg : Theme.fg
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize
        }
    }

    // Breadcrumb header — same pattern as PowerMenu's confirm view.
    component Header: MouseArea {
        id: h
        property string label
        signal back()

        Layout.fillWidth: true
        implicitWidth: hRow.implicitWidth + 16
        implicitHeight: 26
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
        onClicked: h.back()

        Rectangle {
            anchors.fill: parent
            radius: 6
            color: parent.containsMouse ? Theme.bgAlt : "transparent"
        }
        RowLayout {
            id: hRow
            anchors.fill: parent
            anchors.leftMargin: 6
            anchors.rightMargin: 8
            spacing: 8

            Text {
                text: ""  // fa-chevron-left
                color: Theme.fgDim
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize
            }
            Text {
                text: h.label
                color: Theme.fg
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize
                font.bold: true
                Layout.fillWidth: true
                elide: Text.ElideRight
            }
        }
    }

    component ConnRow: MouseArea {
        id: r
        property string label
        property string status
        property color statusColor: Theme.fgDim
        property bool isUp: false
        property bool busy: false
        signal triggered()

        Layout.fillWidth: true
        Layout.minimumWidth: 240
        implicitHeight: rowLayout.implicitHeight + 12
        cursorShape: busy ? Qt.ArrowCursor : Qt.PointingHandCursor
        hoverEnabled: true
        enabled: !busy
        onClicked: r.triggered()

        Rectangle {
            anchors.fill: parent
            radius: 6
            color: parent.containsMouse && !r.busy ? Theme.bgAlt : "transparent"
        }

        RowLayout {
            id: rowLayout
            anchors.fill: parent
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            spacing: 10

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 0

                Text {
                    text: r.label
                    color: Theme.fg
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize
                }
                Text {
                    text: r.busy ? "working…" : r.status
                    color: r.statusColor
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize - 2
                }
            }

            Rectangle {
                implicitWidth: 8
                implicitHeight: 8
                radius: 4
                color: r.isUp ? Theme.ok : Theme.fgDim
                opacity: r.busy ? 0.4 : 1
            }
        }
    }

    // ----- Layout -----------------------------------------------------------

    ColumnLayout {
        spacing: 2

        // List view ----------------------------------------------------------
        ColumnLayout {
            visible: root.view === "list"
            spacing: 2

            ConnRow {
                label: "Work (OpenVPN)"
                isUp: Vpn.openvpnUp
                busy: Vpn.openvpnBusy
                status: {
                    switch (Vpn.openvpnState) {
                        case "up": return "connected"
                        case "connecting": return "starting…"
                        case "auth": return "authenticating…"
                        case "error": return Vpn.openvpnError || "error"
                        default: return "disconnected"
                    }
                }
                statusColor: Vpn.openvpnState === "error" ? Theme.err
                           : Vpn.openvpnUp ? Theme.ok : Theme.fgDim
                onTriggered: {
                    if (Vpn.openvpnUp || Vpn.openvpnBusy) {
                        Vpn.stopOpenvpn()
                    } else {
                        root.view = "auth"
                    }
                }
            }

            ConnRow {
                label: "Personal (WireGuard)"
                isUp: Vpn.wireguardUp
                busy: Vpn.wireguardBusy
                status: Vpn.wireguardUp ? "connected (wg0)" : "disconnected"
                statusColor: Vpn.wireguardUp ? Theme.ok : Theme.fgDim
                onTriggered: Vpn.wireguardUp ? Vpn.stopWireguard() : Vpn.startWireguard()
            }
        }

        // Auth view ----------------------------------------------------------
        ColumnLayout {
            visible: root.view === "auth"
            spacing: 6
            Layout.minimumWidth: 240

            Header {
                label: "Work (OpenVPN)"
                onBack: root.view = "list"
            }

            Field {
                placeholder: "username"
                text: root.formUser
                autoFocus: root.view === "auth" && root.formUser === ""
                onTextChanged: root.formUser = text
                onSubmit: connectBtn.triggered()
            }
            Field {
                placeholder: "password"
                secret: true
                text: root.formPassword
                autoFocus: root.view === "auth" && root.formUser !== ""
                onTextChanged: root.formPassword = text
                onSubmit: connectBtn.triggered()
            }
            Field {
                placeholder: "Duo passcode"
                text: root.formOtp
                onTextChanged: root.formOtp = text
                onSubmit: connectBtn.triggered()
            }

            PrimaryButton {
                id: connectBtn
                label: "Connect"
                enabled: root.formUser !== "" && root.formPassword !== "" && root.formOtp !== ""
                onTriggered: {
                    Vpn.startOpenvpn(root.formUser, root.formPassword, root.formOtp)
                    root.formPassword = ""
                    root.formOtp = ""
                    root.view = "list"
                }
            }
        }
    }
}
