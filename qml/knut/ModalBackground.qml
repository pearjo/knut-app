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
import QtGraphicalEffects 1.14
import QtQuick 2.14
import QtQuick.Controls 2.14
import Theme 1.0

//! A item that displays a blurred and dimmed modal background.
Item {
    id: root

    FastBlur {
        anchors.fill: parent

        radius: 32
        source: !!ApplicationWindow.window ? ApplicationWindow.window.contentItem
                                           : null
    }

    Rectangle { anchors.fill: parent; color: Theme.darkLayer }

    Behavior on opacity {
        NumberAnimation {
            easing.type: Easing.OutCubic
            duration: Theme.animationDuration
        }
    }
}
