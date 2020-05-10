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

Rectangle {
    id: root

    //! This property holds the text displayed within the button.
    property string text: qsTr("Button")

    //! Emitted when the button is clicked.
    signal clicked()

    implicitHeight: 36
    implicitWidth: Math.max(64, (buttonText.contentWidth
                                 + 2 * Theme.horizontalMargin))

    color: Theme.background
    radius: Theme.radius

    Rectangle {
        id: darkOverlay

        anchors.fill: parent

        color: Theme.darkLayer
        radius: parent.radius
    }

    Text {
        id: buttonText

        anchors {
            fill: parent
            bottomMargin: Theme.verticalMargin
            leftMargin: Theme.horizontalMargin
            rightMargin: Theme.horizontalMargin
            topMargin: Theme.verticalMargin
        }

        color: Theme.textForeground
        font: Theme.fontButton
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: root.text
    }

    MouseArea {
        id: button

        anchors.fill: parent

        onClicked: root.clicked()
    }
}
