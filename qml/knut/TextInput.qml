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
