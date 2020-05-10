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
import Knut 1.0
import QtQuick 2.14
import QtQuick.Controls 2.14
import Theme 1.0

import "." as Task
import "../knut" as Knut

//! Displays a ListView with all available Knut tasks.
Item {
    id: root

    implicitHeight: Theme.referenceHeight
    implicitWidth: Theme.referenceWidth

    ListView {
        id: listView

        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: addButton.top
            bottomMargin: addButton.anchors.bottomMargin
        }

        clip: true
        model: !!taskClient ? taskClient.taskModel : undefined

        delegate: Task.Task {
            anchors {
                left: parent.left
                right: parent.right
            }

            task: model.task
        }

        header: Knut.ListViewHeader {
            anchors {
                left: parent.left
                right: parent.right
            }

            title: qsTr("Tasks")
        }

        section {
            delegate: sectionHeading
            property: "dueType"
        }

        Component {
            id: sectionHeading

            Rectangle {
                implicitHeight: 36
                implicitWidth: parent.width

                color: Theme.background

                Text {
                    anchors {
                        left: parent.left
                        leftMargin: Theme.horizontalMargin
                        verticalCenter: parent.verticalCenter
                    }

                    color: Theme.textAccent
                    font: Theme.fontButton
                    text: {
                        switch (parseInt(section)) {
                        case KnutTask.Overdue:
                            return qsTr("Overdue");
                        case KnutTask.Today:
                            return qsTr("Today");
                        case KnutTask.Tomorrow:
                            return qsTr("Tomorrow");
                        case KnutTask.ThisWeek:
                            return qsTr("This week");
                        case KnutTask.Later:
                            return qsTr("After this week");
                        default:
                            return ""
                        }
                    }
                }
            }
        }

        Popup {
            id: popup

            anchors.centerIn: parent

            background: Rectangle { anchors.fill: parent; color: "transparent" }
            closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
            focus: true
            modal: true
            parent: Overlay.overlay

            contentItem: Task.TaskEditPopupItem {
                id: editPopup

                anchors.fill: parent

                popupTitle: qsTr("New task")

                onEditingFinished: {
                    taskClient.addTask(
                        editPopup.assignee,
                        editPopup.body,
                        editPopup.due,
                        editPopup.reminder,
                        editPopup.title
                    );

                    popup.close();
                }
            }

            onOpened: {
                editPopup.assignee = "";
                editPopup.body = "";
                // default due is in one hour
                editPopup.due = new Date(Date.now() + 3600000);
                // default reminder is 10 minutes before due
                editPopup.reminder = new Date(Date.now() + 3000000);
                editPopup.title = "";
            }

            Overlay.modal: Knut.ModalBackground {}
        }
    }

    Knut.ActionButton {
        id: addButton

        anchors {
            right: parent.right
            bottom: parent.bottom
            rightMargin: 16
            bottomMargin: 16
        }

        source: "../../images/icons/add.svg"

        onClicked: popup.open()
    }
}
