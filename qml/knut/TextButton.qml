import QtQuick 2.14

import Theme 1.0

Rectangle {
    id: root

    property string text: qsTr("Button")

    signal clicked()

    implicitHeight: 36
    implicitWidth: Math.max(64, (buttonText.contentWidth
                                 + 2 * Theme.horizontalMargin))

    color: Theme.background
    radius: Theme.radius

    Rectangle {
        id: darkOverlay

        anchors.fill: parent

        color: Theme.darkLayer
        radius: parent.radius
    }

    Text {
        id: buttonText

        anchors {
            fill: parent
            bottomMargin: Theme.verticalMargin
            leftMargin: Theme.horizontalMargin
            rightMargin: Theme.horizontalMargin
            topMargin: Theme.verticalMargin
        }

        color: Theme.textForeground
        font: Theme.fontButton
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: root.text
    }

    MouseArea {
        id: button

        anchors.fill: parent

        onClicked: root.clicked()
    }
}
