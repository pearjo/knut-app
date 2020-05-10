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

Rectangle {
    id: root

    //! Specifies whether the task edit source mode should be active or not.
    property alias editSource: editSourceButton.checked
    //! Whether the reminder edit field is visible or not.
    property bool reminderOpen: false

    implicitHeight: reminderOpen ? rootColumn.height : buttonRow.height
    implicitWidth: Theme.referenceWidth

    color: Theme.backgroundElevated
    clip: true

    Column {
        id: rootColumn

        anchors {
            left: parent.left
            right: parent.right
        }

        Item {
            id: buttonRow

            height: 56
            width: parent.width

            Knut.ToggleButton {
                id: editSourceButton

                anchors {
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                    rightMargin: Theme.horizontalMargin
                }

                checkable: true
                source: "../../images/icons/other/markdown-mark/markdown-mark-solid.svg"

                onClicked: checked = !checked
            }

            /* Knut.TextButton { */
            /*     id: editSourceButton */

            /*     anchors { */
            /*         right: parent.right */
            /*         verticalCenter: parent.verticalCenter */
            /*         rightMargin: Theme.horizontalMargin */
            /*     } */

            /*     checkable: true */
            /*     text: "[M\u2B07]" */
            /* } */

            Knut.TextButton {
                id: reminderButton

                anchors {
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                    leftMargin: Theme.horizontalMargin
                }

                checkable: true
                checked: reminderOpen
                text: qsTr("Reminder")

                onClicked: reminderOpen = !reminderOpen
            }
        }

        Item {
            id: reminderRow

            height: childrenRect.height + 2 * Theme.verticalItemSpace
            width: parent.width

            Knut.TextInput {
                id: dateInput

                width: 0.5 * (parent.width
                              - Theme.horizontalItemSpace) - Theme.horizontalMargin

                anchors {
                    left: parent.left
                    leftMargin: Theme.horizontalMargin
                }

                helperText: "Date"
                label: qsTr("dd.mm.yyyy")
                textInput.inputMethodHints: Qt.ImhDate
            }

            Knut.TextInput {
                id: timeInput

                width: 0.5 * (parent.width
                              - Theme.horizontalItemSpace) - Theme.horizontalMargin

                anchors {
                    right: parent.right
                    rightMargin: Theme.horizontalMargin
                }

                helperText: "Time"
                label: qsTr("hh:mm")
                textInput.inputMethodHints: Qt.ImhTime
            }
        }
    }

    Behavior on height {
        NumberAnimation {
            duration: Theme.animationDuration
            easing.type: Easing.OutCubic
        }
    }
}
