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

Item {
    id: root

    property real __remainingTime: Math.min(
        (due.getTime() - now) / (due.getTime() - reminder.getTime()), 1
    )
    property real now: Date.now()
    property real updateRate: 1000
    property var due: dummytask.due
    property var reminder: dummytask.reminder

    implicitHeight: 24
    implicitWidth: 200

    Rectangle {
        width: root.availableWidth

        color: "transparent"
        y: root.height / 2 - height / 2

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
            width: root.__remainingTime * (root.width - icon.width)

            anchors.verticalCenter: parent.verticalCenter

            color: Theme.controlForeground
            radius: 1
        }
    }

    Knut.ColorIcon {
        id: icon

        height: parent.height
        width: parent.height

        source: "../../images/icons/other/material/alarm-24px.svg"
        color: Theme.accent
        x: root.__remainingTime * (root.width - width)
        y: root.height / 2 - height / 2
    }

    Behavior on __remainingTime {
        NumberAnimation {
            easing.type: Easing.Linear
            duration: updateRate
        }
    }
}
