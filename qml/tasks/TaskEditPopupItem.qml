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
import Knut.Controls 1.0 as Knut
import Knut.Theme 1.0
import QtQuick 2.14
import QtQuick.Layouts 1.14

import "." as Task

//! A pop-up item to edit a task.
Item {
    id: root

    property alias assignee: assigneeInput.text
    property alias body: bodyTextField.text
    property alias popupTitle: headerText.text
    property alias title: titleInput.text
    property var due: new Date()
    property var reminder: new Date()

    signal editingFinished

    implicitHeight: 0.8 * Theme.referenceHeight
    implicitWidth: 0.8 * Theme.referenceWidth

    Rectangle {
        id: background

        anchors.fill: parent

        color: Theme.background
        opacity: Theme.popupOpacity
        radius: Theme.radius
    }

    ColumnLayout {
        id: rootColumn

        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: addButton.top
            topMargin: Theme.verticalMargin
            bottomMargin: Theme.verticalMargin
            leftMargin: Theme.horizontalMargin
            rightMargin: Theme.horizontalMargin
        }

        spacing: Theme.verticalItemSpace

        Text {
            id: headerText

            Layout.preferredHeight: 36
            Layout.preferredWidth: parent.width

            color: Theme.textAccent
            font: Theme.fontH6
            text: qsTr("Edit task")
            verticalAlignment: Text.AlignVCenter
        }

        Item {
            id: taskEntries

            property bool showMore: false

            Layout.preferredHeight: height
            Layout.preferredWidth: parent.width

            implicitHeight: childrenRect.height

            clip: true

            Knut.TextInput {
                id: titleInput

                anchors {
                    left: parent.left
                    right: parent.right
                }

                helperText: ""
                label: qsTr("Title")
            }

            Column {
                id: moreColumn

                anchors {
                    left: parent.left
                    right: parent.right
                    top: titleInput.bottom
                    topMargin: Theme.verticalItemSpace
                }

                spacing: Theme.verticalItemSpace

                Knut.TextInput {
                    id: assigneeInput

                    anchors {
                        left: parent.left
                        right: parent.right
                    }

                    helperText: ""
                    label: qsTr("Assignee")
                }

                Knut.DateTimeInput {
                    id: dueDateTimeInput

                    anchors {
                        left: parent.left
                        right: parent.right
                    }

                    date: root.due
                    helperText: ""
                    label: qsTr("Due")
                    title: qsTr("Set a due date")

                    Binding {
                        target: root
                        property: "due"
                        value: dueDateTimeInput.date
                    }
                }

                Knut.DateTimeInput {
                    id: reminderDateTimeInput

                    anchors {
                        left: parent.left
                        right: parent.right
                    }

                    date: root.reminder
                    helperText: ""
                    label: qsTr("Reminder")
                    title: qsTr("Set a reminder")

                    Binding {
                        target: root
                        property: "reminder"
                        value: reminderDateTimeInput.date
                    }
                }
            }

            states: [
                State {
                    name: "less"
                    when: !taskEntries.showMore

                    PropertyChanges {
                        target: taskEntries
                        height: titleInput.height
                    }
                },
                State {
                    name: "more"
                    when: taskEntries.showMore

                    PropertyChanges {
                        target: taskEntries
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

        Knut.TextButton {
            id: moreButton

            text: taskEntries.showMore ? qsTr("show less") : qsTr("more")

            onClicked: taskEntries.showMore = !taskEntries.showMore
        }

        Item {
            id: bodyHeader

            Layout.preferredHeight: childrenRect.height
            Layout.preferredWidth: parent.width

            Text {
                id: bodyEditText

                anchors {
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                }

                color: Theme.textAccent
                font: Theme.fontCaption
                text: qsTr("Description")
            }

            Knut.ToggleButton {
                id: editSourceButton

                anchors {
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }

                checkable: true
                checked: bodyTextField.editSource
                source: "../../images/icons/other/markdown-mark/markdown-mark-solid.svg"

                onClicked: bodyTextField.editSource = !bodyTextField.editSource
            }
        }

        Knut.MarkdownTextArea {
            id: bodyTextField

            Layout.fillHeight: true
            Layout.preferredWidth: parent.width

            background.color: "transparent"
            placeholderText: qsTr("Description")

            onActiveFocusChanged: {
                if (activeFocus)
                    taskEntries.showMore = false;
            }
        }
    }

    Knut.ActionButton {
        id: addButton

        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.bottom
        }

        source: "../../images/icons/other/material/check-24px.svg"

        onClicked: root.editingFinished()
    }
}
