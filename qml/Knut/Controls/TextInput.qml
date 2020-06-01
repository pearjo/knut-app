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

//! An extended TextInput which displays a \a label if the input is empty.
Item {
    id: root

    //! A label which is displayed if the TextInput is empty.
    property string label: qsTr("Label")
    //! A helper text which is displayed beneath the TextInput
    property string helperText: qsTr("Helper Text")

    //! The input text.
    property alias text: textInput.text
    //! The QtQuick TextInput.
    property alias textInput: textInput

    implicitHeight: helperText !== "" ? childrenRect.height
                                      : textInputItem.height
    implicitWidth: 280

    Rectangle {
        id: textInputItem

        height: 56
        width: parent.width

        color: Theme.background

        Rectangle { anchors.fill: parent; color: Theme.darkLayer }

        Rectangle {
            id: editLine

            height: 1

            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }

            color: Theme.accent
        }

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

        TextInput {
            id: textInput

            anchors {
                baseline: labelText.baseline
                baselineOffset: 20
                left: labelText.left
                right: labelText.right
            }

            color: Theme.textForeground
            font: Theme.fontBody1
            verticalAlignment: Text.AlignVCenter
        }

        MouseArea {
            id: focusButton

            anchors.fill: parent

            enabled: !textInput.activeFocus

            onClicked: textInput.forceActiveFocus()
        }
    }

    Text {
        id: helperTextItem

        anchors {
            left: parent.left
            leftMargin: Theme.horizontalMargin
            right: parent.right
            rightMargin: Theme.horizontalMargin
            top: textInputItem.bottom
            topMargin: Theme.verticalMargin
        }

        color: Theme.textAccent
        text: root.helperText
        font: Theme.fontCaption
    }

    // default is when input is not empty and has no active focus
    states: [
        State {
            name: "edit"
            when: textInput.activeFocus

            PropertyChanges {
                target: editLine
                height: 2
            }
        },
        State {
            name: "emptyInput"
            when: textInput.text === "" && !text.activeFocus

            AnchorChanges {
                target: labelText
                anchors {
                    baseline: undefined
                    top: parent.top
                    bottom: parent.bottom
                }
            }
            PropertyChanges {
                target: editLine
                color: Theme.foreground
                opacity: Theme.opacity
            }
            PropertyChanges {
                target: labelText
                verticalAlignment: Text.AlignVCenter
                color: Theme.textForeground
                opacity: Theme.opacity
                font: textInput.font
            }
        }
    ]
}
