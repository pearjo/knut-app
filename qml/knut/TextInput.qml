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

import Theme 1.0

//! An extended TextInput which displays a \a label if the input is empty.
Item {
    id: root

    //! A label which is displayed if the TextInput is empty.
    property string label: qsTr("Label")
    //! A helper text which is displayed beneath the TextInput
    property string helperText: qsTr("Helper Text")

    //! The input text.
    property alias text: textInput.text
    property alias textInput: textInput

    implicitHeight: helperText !== "" ? childrenRect.height
                                      : textInputItem.height
    implicitWidth: 280

    Rectangle {
        id: textInputItem

        height: 56
        width: parent.width

        color: Theme.background
        radius: Theme.radius

        Rectangle {
            id: darkOverlay

            anchors.fill: parent

            color: Theme.darkLayer
            radius: parent.radius
        }

        TextInput {
            id: textInput

            anchors {
                fill: parent
                leftMargin: Theme.horizontalMargin
                rightMargin: Theme.horizontalMargin
                topMargin: Theme.verticalMargin
                bottomMargin: Theme.verticalMargin
            }

            color: Theme.textForeground
            font: Theme.fontBody1
            verticalAlignment: Text.AlignVCenter
        }

        Text {
            id: labelText

            anchors.fill: textInput

            color: Theme.textBackground
            font: textInput.font
            text: root.label
            verticalAlignment: Text.AlignVCenter
            visible: textInput.text === ""
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
}
