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

import "." as Knut

Item {
    id: actionButton

    property bool checkable: false
    property bool checked: false
    property alias source: buttonIcon.source

    signal clicked()

    implicitHeight: 56
    implicitWidth: 56

    Rectangle {
        id: background

        anchors.fill: parent

        color: Theme.background
        radius: height / 2

        Rectangle {
            id: brightLayer

            anchors.fill: parent

            color: Theme.brightLayer
            radius: height / 2
        }
    }

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

    Knut.ColorIcon {
        id: buttonIcon

        height: 24
        width: height

        anchors.centerIn: parent

        color: actionButton.checkable && actionButton.checked ? Theme.accent
                                                              : Theme.foreground
        icon.fillMode: Image.PreserveAspectFit
    }

    MouseArea {
        id: button

        anchors.fill: parent

        onClicked: actionButton.clicked()
    }
}
