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
import QtQuick.Layouts 1.14
import Theme 1.0

import "." as Knut

Item {
    id: confirmationPopupItem

    property string text: "Are you sure about what will happen?"

    signal clicked(bool ok)

    implicitHeight: column.height
    implicitWidth: column.width

    Rectangle {
        id: background

        anchors.fill: parent

        color: Theme.background
        opacity: Theme.opacity
        radius: Theme.radius
    }

    Column {
        id: column

        anchors.centerIn: parent

        leftPadding: Theme.horizontalMargin
        rightPadding: Theme.horizontalMargin
        bottomPadding: Theme.verticalMargin
        topPadding: Theme.verticalMargin
        spacing: Theme.verticalItemSpace

        Text {
            id: confirmationText

            anchors.horizontalCenter: parent.horizontalCenter

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font: Theme.fontH6
            color: Theme.textForeground
            text: confirmationPopupItem.text
            wrapMode: Text.Wrap
            elide: Text.ElideRight
            clip: true
        }

        Row {
            id: buttonRow

            anchors.horizontalCenter: parent.horizontalCenter

            spacing: Theme.horizontalItemSpace

            Knut.Button {
                id: cancleButton

                text: qsTr("Cancle")

                onClicked: confirmationPopupItem.clicked(false)
            }

            Knut.Button {
                id: okButton

                text: qsTr("Ok")

                onClicked: confirmationPopupItem.clicked(true)
            }
        }
    }
}
