import QtGraphicalEffects 1.14
import QtQuick 2.14
import QtQuick.Controls 2.14

import Theme 1.0

Slider {
    id: root

    signal released()

    implicitHeight: 24
    implicitWidth: 200

    background: Rectangle {
        width: root.availableWidth

        color: "transparent"
        x: root.leftPadding
        y: root.topPadding + root.availableHeight / 2 - height / 2

        Rectangle {
            height: 2
            width: parent.width

            anchors.verticalCenter: parent.verticalCenter

            color: Theme.controlForeground
            opacity: 0.2
            radius: 1
        }

        Rectangle {
            height: 2
            width: root.visualPosition * parent.width

            anchors.verticalCenter: parent.verticalCenter

            color: Theme.controlForeground
            radius: 1
        }
    }

    handle: Rectangle {
        height: parent.height
        width: parent.height

        color: root.pressed ? Theme.foregroundPressed : Theme.foreground
        radius: 13
        x: root.leftPadding + root.visualPosition * (root.availableWidth - width)
        y: root.topPadding + root.availableHeight / 2 - height / 2
    }

    DropShadow {
        anchors.fill: handle

        cached: true
        color: Theme.shadowColor
        horizontalOffset: Theme.shadowHorizontalOffset
        radius: Theme.shadowRadius
        samples: Theme.shadowSamples
        source: handle
        verticalOffset: Theme.shadowVerticalOffset
    }

    onPressedChanged: {
        if (!pressed)
            released();
    }
}
