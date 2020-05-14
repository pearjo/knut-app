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
import QtQuick 2.14

import Theme 1.0

import "." as Knut

Item {
    id: root

    property bool checkable: false
    property bool checked: false
    property alias source: buttonIcon.source

    signal clicked()

    implicitHeight: 48
    implicitWidth: 48

    Knut.ColorIcon {
        id: buttonIcon

        anchors {
            fill: parent
            margins: 12
        }

        color: root.checkable && !root.checked ? Theme.controlInactive
                                               : Theme.controlActive
        icon.fillMode: Image.PreserveAspectFit
    }

    MouseArea {
        id: button

        anchors.fill: parent

        onClicked: root.clicked()
    }
}
