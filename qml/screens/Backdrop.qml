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
import QtQuick 2.14
import QtQuick.Controls 2.14

import "../lights" as Lights
import "../tasks" as Tasks
import "../temperature" as Temperature

Item {
    id: backdrop

    property bool isOpen: false

    implicitHeight: isOpen ? backdropColumn.height : 0
    implicitWidth: Theme.referenceWidth

    clip: true

    Column {
        id: backdropColumn

        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }

        bottomPadding: Theme.verticalMargin
        topPadding: Theme.verticalMargin

        Tasks.BackdropTask { width: parent.width }
        Temperature.BackdropLocalWeather { width: parent.width }
        Lights.BackdropLightControl { width: parent.width }
    }

    Behavior on implicitHeight {
        NumberAnimation {
            duration: Theme.animationDuration
            easing.type: Easing.OutCubic
        }
    }
}
