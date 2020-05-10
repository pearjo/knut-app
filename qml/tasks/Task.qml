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
import QtQml 2.14

import Knut 1.0
import Theme 1.0

import "." as Task
import "../knut" as Knut

//! A item that displays a Knut task.
FocusScope {
    id: root

    //! This property holds the Knut \a Task which is representet by this item.
    property var task: dummytask

    property bool __isOpen: false

    readonly property real __itemHeight: 76

    implicitHeight: __isOpen ? rootColumn.height : __itemHeight
    implicitWidth: Theme.referenceWidth

    clip: true

    Connections {
        target: task
        onRemind: notificationPopup.open()
    }

    Binding {
        property: "text"
        restoreMode: Binding.RestoreBinding
        target: bodyTextField
        value: task.body
        when: !bodyTextField.activeFocus
    }

    Rectangle {
        id: background

        anchors.fill: parent

        color: __isOpen ? Theme.backgroundElevated : Theme.background
    }

    MouseArea {
        id: extendButton

        anchors.fill: parent

        onClicked: {
            __isOpen = !__isOpen;
            root.forceActiveFocus();
        }
    }

    Column {
        id: rootColumn

        height: childrenRect.height
        width: parent.width

        Item {
            id: topItem

            height: __itemHeight

            anchors {
                left: parent.left
                leftMargin: Theme.horizontalMargin
                right: parent.right
                rightMargin: Theme.horizontalMargin
            }

            Task.BulletJournalCheckBox {
                id: doneCheckBox

                anchors.left: parent.left

                done: task.done
                color: Theme.foreground
                opacity: Theme.opacity

                onClicked: {
                    task.done = done;
                    if (done)
                        deletePopup.open();
                }
            }

            Item {
                id: descriptionItem

                implicitHeight: childrenRect.height

                anchors {
                    left: doneCheckBox.right
                    right: taskEditButton.left
                    verticalCenter: parent.verticalCenter
                }

                Text {
                    id: titleText

                    height: contentHeight
                    width: parent.width

                    anchors {
                        left: parent.left
                        top: parent.top
                    }

                    color: Theme.textForeground
                    elide: Text.ElideRight
                    font: Theme.fontH6
                    opacity: task.done ? Theme.opacity : 1
                    text: task.title

                    Rectangle {
                        id: doneLine

                        height: 2
                        width: task.done ? parent.contentWidth : 0

                        anchors {
                            left: parent.left
                            verticalCenter: parent.verticalCenter
                        }

                        color: parent.color

                        Behavior on width {
                            NumberAnimation {
                                duration: Theme.animationDuration
                                easing.type: Easing.OutCubic
                            }
                        }
                    }
                }

                Text {
                    id: infoText

                    readonly property string dueInfo: {
                        switch (task.dueType) {
                        case KnutTask.Overdue:
                            return task.done ? qsTr("Done")
                                             : qsTr("Task is overdue");
                        case KnutTask.Today:
                            return (qsTr("Due")
                                    + " "
                                    + task.due.toLocaleTimeString("hh:mm"))
                        case KnutTask.Tomorrow:
                            return (qsTr("Due tomorrow")
                                    + " "
                                    + task.due.toLocaleTimeString("hh:mm"));
                        case KnutTask.ThisWeek:
                            return (qsTr("Due on")
                                    + " "
                                    + infoText.weekdays[task.due.getDay()]);
                        case KnutTask.Later:
                            return (qsTr("Due on")
                                    + " "
                                    + task.due.toLocaleDateString())
                        default:
                            return "Unknown due date"
                        }
                    }
                    readonly property var weekdays: [qsTr("Sunday"),
                                                     qsTr("Monday"),
                                                     qsTr("Tuesday"),
                                                     qsTr("Wednesday"),
                                                     qsTr("Thursday"),
                                                     qsTr("Friday"),
                                                     qsTr("Saturday")]

                    height: contentHeight
                    width: parent.width

                    anchors {
                        left: parent.left
                        top: titleText.bottom
                        topMargin: Theme.verticalMargin
                    }

                    color: Theme.textForeground
                    elide: Text.ElideRight
                    font: Theme.fontSubtitle1
                    opacity: Theme.opacity
                    text: task.assignee !== "" ? dueInfo + " • " + task.assignee
                                               : dueInfo
                }
            }

            Knut.ToggleButton {
                id: taskEditButton

                anchors {
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }

                source: "../../images/icons/other/material/create-24px.svg"
                visible: !!ApplicationWindow.window && __isOpen

                onClicked: {
                    if (!!ApplicationWindow.window) {
                        bodyTextField.editingFinished();
                        editPopup.open();
                        __isOpen = false;
                    }
                }
            }
        }

        Column {
            id: bodyItem

            anchors {
                left: parent.left
                right: parent.right
                leftMargin: Theme.horizontalMargin
                rightMargin: Theme.horizontalMargin
            }

            Knut.MarkdownTextArea {
                id: bodyTextField

                height: 200

                anchors {
                    left: parent.left
                    right: parent.right
                }

                background.color: "transparent"
                placeholderText: qsTr("Description")
                text: task.body

                onEditingFinished: task.body = text
            }

            Knut.ToggleButton {
                id: taskDeleteButton

                anchors.right: parent.right

                source: "../../images/icons/other/material/delete-24px.svg"

                onClicked: {
                    bodyTextField.editingFinished();
                    __isOpen = false;
                    deletePopup.open();
                }
            }
        }
    }

    Knut.NotificationPopup {
        id: notificationPopup

        width: 0.6 * parent.width

        message: task.title
    }

    Task.EditPopup {
        id: editPopup

        height: 0.8 * parent.height
        width: 0.8 * parent.width

        assignee: task.assignee
        body: task.body
        due: task.due
        reminder: task.reminder
        title: task.title

        onEditingFinished: {
            task.assignee = editPopup.assignee;
            task.body = editPopup.body;
            task.due = editPopup.due;
            task.reminder = editPopup.reminder;
            task.title = editPopup.title;
        }
    }

    Task.DeletePopup {
        id: deletePopup

        width: parent.width * 0.8
        task: root.task
    }

    onActiveFocusChanged: !activeFocus ? __isOpen = false : undefined

    onStateChanged: {
        if (state === "closed")
            bodyTextField.editingFinished();
    }

    states: [
        State {
            name: "closed"
            when: !__isOpen

            PropertyChanges {
                target: root
                height: __itemHeight
            }
        },
        State {
            name: "opened"
            when: __isOpen

            PropertyChanges {
                target: root
                height: implicitHeight
            }
        }
    ]

    Behavior on height {
        NumberAnimation {
            duration: Theme.animationDuration
            easing.type: Easing.OutCubic
        }
    }
}
