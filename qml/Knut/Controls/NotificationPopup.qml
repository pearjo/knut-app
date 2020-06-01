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

import "." as Knut

/*! \brief Notification popup that can display a message.
 *
 *  NotificationPopup is a Popup displaying a notification message and a
 *  confirmation button. The confirmation button emits the signal confirmed()
 *  and closes when it is clicked by the user.
 */
Popup {
    id: notificationPopup

    //! This property holds the notification message.
    property alias message: messageText.text

    signal confirmed()

    anchors.centerIn: parent

    background: Rectangle { anchors.fill: parent; color: "transparent" }
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    focus: true
    modal: true
    parent: Overlay.overlay

    contentItem: Item {
        id: notificationPopupItem

        implicitHeight: column.height

        Rectangle {
            id: background

            anchors.fill: parent

            color: Theme.background
            opacity: Theme.opacity
            radius: Theme.radius
        }

        Column {
            id: column

            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                leftMargin: Theme.horizontalMargin
                rightMargin: Theme.horizontalMargin
            }

            bottomPadding: Theme.verticalMargin
            topPadding: Theme.verticalMargin
            spacing: Theme.verticalItemSpace

            Knut.ColorIcon {
                anchors.horizontalCenter: parent.horizontalCenter
                color: Theme.accent
                source: "../../../images/icons/other/material/notifications_none-24px.svg"
            }

            Text {
                id: messageText

                anchors.horizontalCenter: parent.horizontalCenter

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font: Theme.fontH6
                color: Theme.textForeground
                text: qsTr("You got a notification!")
                wrapMode: Text.Wrap
                elide: Text.ElideRight
                clip: true
            }

            Knut.Button {
                id: button

                anchors.horizontalCenter: parent.horizontalCenter

                text: qsTr("Ok")

                onClicked: {
                    notificationPopup.confirmed();
                    notificationPopup.close();
                }
            }
        }
    }


    Overlay.modal: Knut.ModalBackground {}
}
