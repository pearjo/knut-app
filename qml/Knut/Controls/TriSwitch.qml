/* Copyright (C) 2020  Joe Pearson
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */
import Knut.Theme 1.0
import QtGraphicalEffects 1.14
import QtQuick 2.14
import QtQuick.Controls 2.14

/*! \brief Displays a switch with three states.
 *
 *  This switch can have the three values \c -1, \c 0 and \c 1.  By clicking
 *  the switch, the values \c -1 and \c 1 can only be set. However, from QML the
 *  value can be also set to \c 0.
 */
Slider {
    id: root

    /*! \brief This property represents the boolean value of the switch.
     *
     *  If \a value is greater zero, the \a boolValue will be \c true.
     */
    readonly property bool boolValue: value > 0 ? true : false

    readonly property real __activeWidth: Math.max(0.5 * width
                                                   * (1 + p.triState),
                                                   height)

    //! Emitted when the switch is clicked.
    signal clicked()

    implicitHeight: 24
    implicitWidth: 3 * implicitHeight

    from: -1.0
    live: false
    stepSize: 2.0
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
            width: __activeWidth

            color: Theme.switchActive
            radius: parent.radius
        }
    }

    handle: Item {
        height: parent.height
        width: parent.height

        /* x position with triState value ranging from -1 ... 1 */
        x: 0.5 * (root.width - width) * (p.triState + 1)

        Rectangle {
            height: parent.height
            width: parent.width / 2

            anchors.left: parent.left

            color: Theme.switchActive
            visible: 0.5 * __activeWidth > width
        }

        Rectangle {
            id: handleKnob

            anchors.fill: parent

            color: root.pressed ? Theme.foregroundPressed : Theme.light
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
