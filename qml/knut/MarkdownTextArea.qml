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
import QtQml 2.14

import Theme 1.0

/*! A text edit field where the text can either be edited as plain text
 *  supporting the Markdown syntax or as rendered Markdown text.
 */
FocusScope {
    id: root

    //! This property defines the background of the text field.
    property alias background: background

    /*! This property is true if the text is edited as plain text with Markdown
     *  syntax.
     */
    property bool editSource: false

    //! This property defines the text color.
    property color color: Theme.textForeground

    //! This property defines the font style of the tex field.
    property font font: Theme.fontBody1

    /*! This property holds the text shown if no \a text is entered in the text
     *  field.
     */
    property string placeholderText

    //! This property holds the text displayed in the text field.
    property string text

    //!  Emitted when the text editing is finished.
    signal editingFinished

    implicitHeight: 200
    implicitWidth: Theme.referenceWidth

    onEditingFinished: focus = false

    onTextChanged: {
        if (!editText.activeFocus && !markdownText.activeFocus) {
            if (text !== editText.text)
                editText.text = text;
            if (text !== markdownText.text)
                markdownText.text = text;
        }
    }

    Rectangle {
        id: background

        anchors.fill: parent

        color: Theme.background
    }

    Flickable {
        id: flickEdit

        anchors.fill: parent

        clip: true
        contentHeight: editText.contentHeight
        flickableDirection: Flickable.VerticalFlick
        interactive: contentHeight > height
        visible: editSource

        ScrollBar.vertical: ScrollBar {}

        TextArea.flickable: TextArea {
            id: editText

            background: Rectangle { color: "transparent" }
            color: root.color
            font: root.font
            opacity: text === "" ? Theme.opacity : 1
            placeholderText: root.placeholderText
            placeholderTextColor: color
            textFormat: TextEdit.PlainText
            visible: editSource
            wrapMode: TextEdit.Wrap

            onEditingFinished: root.editingFinished()

            Binding {
                property: "text"
                restoreMode: Binding.RestoreBinding
                target: markdownText
                value: editText.text
                when: editSource && editText.activeFocus
            }

            Binding {
                property: "text"
                restoreMode: Binding.RestoreBinding
                target: root
                value: editText.text
                when: editSource && editText.activeFocus
            }
        }
    }

    Flickable {
        id: flickMarkdown

        anchors.fill: parent

        clip: true
        contentHeight: markdownText.contentHeight
        flickableDirection: Flickable.VerticalFlick
        interactive: contentHeight > height
        visible: !editSource

        ScrollBar.vertical: ScrollBar {}

        TextArea.flickable: TextArea {
            id: markdownText

            background: Rectangle { color: "transparent" }
            color: root.color
            font: root.font
            opacity: text === "" ? Theme.opacity : 1
            placeholderText: root.placeholderText
            placeholderTextColor: color
            textFormat: TextEdit.MarkdownText
            visible: !editSource
            wrapMode: editText.wrapMode

            onEditingFinished: root.editingFinished()

            Binding {
                property: "text"
                restoreMode: Binding.RestoreBinding
                target: editText
                value: markdownText.text
                when: !editSource && markdownText.activeFocus
            }

            Binding {
                property: "text"
                restoreMode: Binding.RestoreBinding
                target: root
                value: markdownText.text
                when: !editSource && markdownText.activeFocus
            }
        }
    }
}
