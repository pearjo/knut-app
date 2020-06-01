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

Item {
    id: root

    property bool checkable: false
    property bool checked: false
    property string text: qsTr("Button")

    signal clicked()

    implicitHeight: 36
    implicitWidth: Math.max(64, (buttonText.contentWidth
                                 + 2 * Theme.horizontalMargin))

    Text {
        id: buttonText

        anchors {
            fill: parent
            bottomMargin: Theme.verticalMargin
            leftMargin: Theme.horizontalMargin
            rightMargin: Theme.horizontalMargin
            topMargin: Theme.verticalMargin
        }

        color: root.checkable && root.checked ? Theme.textAccent
                                              : Theme.textForeground
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
