import QtGraphicalEffects 1.14
import QtQuick 2.14

import "../knut" as Knut

import Theme 1.0

Rectangle {
    id: root

    implicitHeight: Theme.referenceHeight
    implicitWidth: Theme.referenceWidth

    color: Theme.background
    enabled: opacity > 0
    opacity: knutClient.hostAddress === "" ? 1 : 0

    Image {
        id: knutIcon

        width: 140

        anchors {
            bottom: loginField.top
            bottomMargin: 56
            horizontalCenter: parent.horizontalCenter
        }

        antialiasing: true
        fillMode: Image.PreserveAspectFit
        source: "../../images/icons/knut.svg"
        sourceSize.height: height
        sourceSize.width: width
        visible: false
    }

    ColorOverlay {
        id: colorOverlay

        anchors.fill: source

        antialiasing: true
        color: Theme.foreground
        source: knutIcon
    }

    Column {
        id: loginField

        width: Math.min(0.8 * parent.width, 280)

        anchors.centerIn: parent

        spacing: Theme.verticalItemSpace

        Knut.TextInput {
            id: hostAddressInput

            helperText: ""
            label: qsTr("Host Address")
        }

        Knut.TextInput {
            id: portInput

            helperText: ""
            label: qsTr("Port")
            textInput.validator: IntValidator {}
        }
    }

    Knut.TextButton {
        id: button

        text: qsTr("Connect")

        anchors {
            top: loginField.bottom
            topMargin: 56
            horizontalCenter: parent.horizontalCenter
        }

        onClicked: {
            if (hostAddressInput !== "" && portInput !== "") {
                knutClient.hostAddress = hostAddressInput.text;
                knutClient.port = parseInt(portInput.text);
            }
        }
    }

    Behavior on opacity {
        NumberAnimation {
            duration: Theme.animationDuration
            easing.type: Easing.OutQuad;
        }
    }
}
