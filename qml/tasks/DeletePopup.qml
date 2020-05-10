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
import QtQuick.Controls 2.14
import Theme 1.0

import "../knut" as Knut

//! A confirmation popup to delete a task.
Popup {
    id: deletePopup

    //! This property holds the Knut \a Task which should be deleted.
    property var task: dummytask

    anchors.centerIn: parent

    background: Rectangle { anchors.fill: parent; color: "transparent" }
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    focus: true
    modal: true
    parent: Overlay.overlay

    contentItem: Knut.ConfirmationPopupItem {
        id: confirmationPopupItem

        text: (qsTr("Delete the task")
               + "<br>"
               + "<i>"
               + task.title
               + "</i> ?")

        onClicked: {
            if (ok)
                taskClient.deleteTask(task);

            deletePopup.close();
        }
    }

    Overlay.modal: Knut.ModalBackground {}
}
