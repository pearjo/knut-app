import QtQuick 2.14

import Theme 1.0

import "../knut" as Knut

//! Displays a Light control to switch single rooms and all Lights at once.
Item {
    id: root

    implicitHeight: childrenRect.height
    implicitWidth: Theme.referenceWidth

    Rectangle {
        id: background

        anchors {
            fill: parent
            leftMargin: Theme.horizontalMargin / 2
            rightMargin: Theme.horizontalMargin / 2
            topMargin: Theme.verticalMargin
            bottomMargin: Theme.verticalMargin
        }

        color: Theme.background
        radius: Theme.radius
    }

    Column {
        id: controlColumn

        anchors {
            left: background.left
            leftMargin: Theme.horizontalMargin / 2
            right: background.right
            rightMargin: Theme.horizontalMargin / 2
        }

        bottomPadding: Theme.verticalMargin
        topPadding: Theme.verticalMargin

        Item {
            id: allLight

            implicitHeight: 72
            implicitWidth: parent.width

            Knut.ColorIcon {
                id: lampIcon

                anchors.verticalCenter: parent.verticalCenter

                color: Theme.accent
                opacity: lightClient.lightStateAll > 0 ? 1.0 : Theme.opacity
                source: "../../images/icons/lamp.svg"
            }

            Text {
                id: lightText

                height: contentHeight
                width: parent.width * 0.5

                anchors {
                    left: lampIcon.right
                    leftMargin: Theme.horizontalItemSpace
                    verticalCenter: parent.verticalCenter
                }

                color: Theme.textAccent
                elide: Text.ElideRight
                font: Theme.fontH5
                text: qsTr("Lights")
            }

            Knut.TriSwitch {
                id: allLightSwitch

                anchors {
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }

                value: lightClient.lightStateAll

                onClicked: lightClient.lightStateAll = value;
            }
        }

        Knut.Divider {
            id: divider

            anchors.left: parent.left
            anchors.right: parent.right
        }

        Repeater {
            id: roomRepeater

            implicitWidth: parent.width

            model: !!lightClient ? lightClient.roomModel : undefined

            delegate: Item {
                implicitHeight: 48

                anchors {
                    left: parent.left
                    right: parent.right
                }

                Text {
                    id: roomText

                    height: contentHeight
                    width: parent.width * 0.5

                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                    }

                    color: Theme.textForeground
                    elide: Text.ElideRight
                    font: Theme.fontH6
                    text: model.roomName
                }

                Knut.TriSwitch {
                    id: roomSwitch

                    anchors {
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                    }

                    value: model.room.roomState

                    onClicked: model.room.roomState = value
                }
            }
        }
    }
}
