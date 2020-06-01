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

//! A input item similar to \a TextInput but for a Date.
Item {
    id: root

    //! A helper text which is displayed beneath the TextInput
    property string helperText: qsTr("Helper Text")

    //! A label which is displayed if the TextInput is empty.
    property string label: qsTr("Label")

    /*! This property holds the title of the \a DateTimePicker which will be
     *  opened when pressing the edit button.
     */
    property string title: qsTr("Title")

    //! This property holds the Date.
    property var date: new Date()

    //! Emitted whenever the \a date should be edited.
    /* signal editClicked */

    implicitHeight: helperText !== "" ? childrenRect.height
                                      : dateTimeInputItem.height
    implicitWidth: 280

    Item {
        id: dateTimeInputItem

        height: 56
        width: parent.width

        Text {
            id: labelText

            anchors {
                baseline: parent.top
                baselineOffset: 20
                left: parent.left
                right: parent.right
                leftMargin: Theme.horizontalMargin
                rightMargin: Theme.horizontalMargin
            }

            color: Theme.textAccent
            font: Theme.fontCaption
            text: root.label
        }

        Text {
            id: dateTimeText

            anchors {
                baseline: labelText.baseline
                baselineOffset: 20
                left: labelText.left
                right: labelText.right
            }

            color: Theme.textForeground
            font: Theme.fontBody1
            verticalAlignment: Text.AlignVCenter
            text: root.date.toLocaleString(Locale.ShortFormat)
        }

        Knut.ToggleButton {
            id: editButton

            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
            }

            source: "../../../images/icons/other/material/create-24px.svg"

            onClicked: {
                forceActiveFocus();
                popup.open();
            }
        }
    }

    Text {
        id: helperTextItem

        anchors {
            left: parent.left
            leftMargin: Theme.horizontalMargin
            right: parent.right
            rightMargin: Theme.horizontalMargin
            top: dateTimeInputItem.bottom
            topMargin: Theme.verticalMargin
        }

        color: Theme.textAccent
        text: root.helperText
        font: Theme.fontCaption
    }

    Popup {
        id: popup

        anchors.centerIn: parent

        background: Rectangle { anchors.fill: parent; color: "transparent" }
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        focus: true
        modal: true
        parent: Overlay.overlay

        contentItem: Knut.DateTimePicker {
            id: editPopup

            anchors.fill: parent

            date: root.date
            title: root.title

            onDateTimeSelected: {
                popup.close();
                root.date = selectedDate;
            }
        }

        Overlay.modal: Knut.ModalBackground {}
    }

    // default is when input is not empty and has no active focus
    states: [
        State {
            name: "emptyInput"
            when: dateTimeText.text === "" && !text.activeFocus

            AnchorChanges {
                target: labelText
                anchors {
                    baseline: undefined
                    top: parent.top
                    bottom: parent.bottom
                }
            }
            PropertyChanges {
                target: labelText
                verticalAlignment: Text.AlignVCenter
                color: Theme.textForeground
                opacity: Theme.opacity
                font: dateTimeText.font
            }
        }
    ]
}
