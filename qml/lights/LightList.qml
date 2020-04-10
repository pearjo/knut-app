import QtQuick 2.14

import Theme 1.0

import "." as Lights
import "../knut" as Knut

//! Displays a ListView with all available LightControl.
ListView {
    id: root

    implicitHeight: Theme.referenceHeight
    implicitWidth: Theme.referenceWidth

    model: !!lightClient ? lightClient.lightModel : undefined

    delegate: Lights.LightControl {
        anchors {
            left: parent.left
            right: parent.right
        }

        light: model.light
    }

    header: Knut.ListViewHeader {
        anchors {
            left: parent.left
            right: parent.right
        }

        title: qsTr("Lights")
    }

    section {
        delegate: sectionHeading
        property: "room"
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
                text: section
            }
        }
    }
}
