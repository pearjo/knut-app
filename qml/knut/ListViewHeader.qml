import QtQuick 2.14

import Theme 1.0

//! The header Item of a ListView.
Rectangle {
    id: root

    /// The \a ListView title text.
    property alias title: titleText.text

    implicitHeight: 48
    implicitWidth: Theme.referenceWidth

    color: Theme.background

    Text {
        id: titleText

        height: contentHeight
        width: parent.width * 0.8

        anchors {
            left: parent.left
            leftMargin: Theme.horizontalMargin
            verticalCenter: parent.verticalCenter
        }

        color: Theme.textAccent
        elide: Text.ElideRight
        font: Theme.fontH5
        verticalAlignment: Text.AlignVCenter
    }
}
