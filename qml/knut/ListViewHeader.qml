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

//! The header Item of a ListView.
Rectangle {
    id: root

    /// The \a ListView title text.
    property alias title: titleText.text

    implicitHeight: 56
    implicitWidth: Theme.referenceWidth

    color: Theme.background

    Text {
        id: titleText

        height: contentHeight
        width: parent.width * 0.8

        anchors {
            left: parent.left
            leftMargin: Theme.horizontalMargin
            verticalCenter: parent.verticalCenter
        }

        color: Theme.textAccent
        elide: Text.ElideRight
        font: Theme.fontH4
        verticalAlignment: Text.AlignVCenter
    }
}
