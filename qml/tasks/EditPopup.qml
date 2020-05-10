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

import "." as Task
import "../knut" as Knut

//! A pop-up which is used to edit a task.
Popup {
    id: editPopup

    property alias assignee: editPopupItem.assignee
    property alias body: editPopupItem.body
    property alias due: editPopupItem.due
    property alias reminder: editPopupItem.reminder
    property alias title: editPopupItem.title

    signal editingFinished

    anchors.centerIn: parent

    background: Rectangle { anchors.fill: parent; color: "transparent" }
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    focus: true
    modal: true
    parent: Overlay.overlay

    contentItem: Task.TaskEditPopupItem {
        id: editPopupItem

        anchors.fill: parent

        onEditingFinished: {
            editPopup.editingFinished();
            editPopup.close();
        }
    }

    Overlay.modal: Knut.ModalBackground {}
}
