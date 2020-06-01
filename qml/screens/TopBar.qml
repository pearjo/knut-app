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
import Knut.Controls 1.0 as Knut
import Knut.Theme 1.0
import QtGraphicalEffects 1.14
import QtQuick 2.14
import QtQuick.Controls 2.14

import "../lights" as Lights
import "../tasks" as Tasks
import "../temperature" as Temperature

/*! \brief Displays the app's top bar.
 *
 *  The TopBar has a AnimatedIconButton on the left side which opends the
 *  backdrop of the TopBar. Beside that button is a TabBar to allow navigation
 *  in the app.
 */
Item {
    id: root

    //! Defines whether the backdrop is open or not
    property bool backdropOpen: false

    //! Size of the TabBar icon buttons
    property real buttonSize: 24

    //! The current TabBar index
    property alias currentIndex: bar.currentIndex

    //! The model with the tab bar icon sources.
    property alias model: barRepeater.model

    implicitHeight: 56
    implicitWidth: Theme.referenceWidth

    Rectangle { id: background; anchors.fill: parent; color: Theme.elevated }

    DropShadow {
        anchors.fill: background

        cached: true
        color: Theme.shadowColor
        horizontalOffset: Theme.shadowHorizontalOffset
        radius: Theme.shadowRadius
        samples: Theme.shadowSamples
        source: background
        verticalOffset: Theme.shadowVerticalOffset
    }

    Knut.AnimatedIconButton {
        id: backdropButton

        implicitHeight: parent.height
        implicitWidth: height

        anchors {
            left: parent.left
            leftMargin: Theme.horizontalMargin
            verticalCenter: parent.verticalCenter
        }

        bottomColor: Theme.accent
        bottomSource: "../../images/icons/close.svg"
        iconSize: root.buttonSize * 1.2
        topColor: Theme.controlForeground
        topSource: "../../images/icons/knut.svg"

        onClicked: root.backdropOpen = !root.backdropOpen

        Component.onCompleted: state = root.backdropOpen ? "bottom" : "top"
    }

    TabBar {
        id: bar

        implicitHeight: parent.height

        anchors {
            left: backdropButton.right
            right: parent.right
            verticalCenter: parent.verticalCenter
            rightMargin: Theme.horizontalMargin
        }

        background: Rectangle { opacity: 0 }

        Repeater {
            id: barRepeater

            delegate: TabButton {
                id: tabButton

                anchors.verticalCenter: parent.verticalCenter

                icon {
                    height: root.buttonSize

                    color: (bar.currentIndex === index) ? Theme.accent
                        : Theme.foreground
                    source: modelData
                }

                background: Rectangle { opacity: 0 }
                opacity: bar.currentIndex === index ? 1.0 : Theme.opacity
            }
        }
    }
}
