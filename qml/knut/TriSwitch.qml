import QtGraphicalEffects 1.14
import QtQuick 2.14
import QtQuick.Controls 2.14

import Theme 1.0

/*! \brief A switch with three states.
 *
 *  This switch can have the three values \c 0, \c 0.5 and \c 1.
 *  A user can only set the switch to \c 0 or \c 1, while a back-end
 *  can set the \a value \c 0.5.
 *
 *  This can be used for example a master ligth switch. The user can switch all
 *  light on or off, but if only one light changes, neither are all lights then
 *  on or off. This state can then be represented by the \a value \c 0.5.
 */
Slider {
    id: root

    //! Boolean representation of the TriSwitch. If \a value is greater zero,
    //! this property is \c true.
    readonly property bool boolValue: value > 0 ? true : false

    signal clicked()

    implicitHeight: 24
    implicitWidth: 3 * implicitHeight

    from: 0.0
    live: false
    stepSize: 1.0
    to: 1.0

    QtObject {
        id: p

        property real triState

        Behavior on triState {
            NumberAnimation {
                id: switchBehavior
                easing.type: Easing.OutCubic
                duration: Theme.animationDuration
            }
        }
    }

    background: Rectangle {
        anchors.fill: parent

        color: Theme.controlInactive
        radius: parent.height / 2

        Rectangle {
            height: parent.height
            width: Math.max(p.triState * parent.width, parent.height)

            color: Theme.controlActive
            radius: parent.radius
        }
    }

    handle: Item {
        height: parent.height
        width: parent.height

        x:  p.triState * (root.width - width)

        Rectangle {
            height: parent.height
            width: parent.width / 2

            anchors.left: parent.left

            color: Theme.controlActive
            visible: root.width * p.triState > width
        }

        Rectangle {
            id: handleKnob

            anchors.fill: parent

            color: root.pressed ? Theme.foregroundPressed : Theme.foreground
            radius: height / 2
        }

        DropShadow {
            anchors.fill: handleKnob

            cached: true
            color: Theme.shadowColor
            horizontalOffset: Theme.shadowHorizontalOffset
            radius: Theme.shadowRadius
            samples: Theme.shadowSamples
            source: handleKnob
            verticalOffset: Theme.shadowVerticalOffset
        }
    }

    Component.onCompleted: p.triState = value

    onPressedChanged: {
        if (!pressed)
            clicked();
    }

    onValueChanged: p.triState = value
}
