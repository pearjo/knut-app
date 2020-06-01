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

        color: root.pressed ? Theme.foregroundPressed : Theme.light
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
