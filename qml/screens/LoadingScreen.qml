import QtGraphicalEffects 1.14
import QtQuick 2.14

import Theme 1.0

Rectangle {
    id: root

    implicitHeight: Theme.referenceHeight
    implicitWidth: Theme.referenceWidth

    color: Theme.background
    opacity: knutClient.connected ? 0 : 1

    Image {
        id: loadingImage

        width: 140

        anchors.centerIn: parent

        antialiasing: true
        fillMode: Image.PreserveAspectFit
        source: "../../images/icons/knut.svg"
        sourceSize.height: height
        sourceSize.width: width
        visible: false
    }

    ColorOverlay {
        id: colorOverlay

        anchors.fill: loadingImage

        antialiasing: true
        color: Theme.foreground
        source: loadingImage
    }

    Behavior on opacity {
        NumberAnimation {
            duration: Theme.animationDuration
            easing.type: Easing.OutQuad;
        }
    }
}
