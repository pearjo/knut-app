import QtQuick 2.14
import QtQuick.Controls 2.14

import Theme 1.0

import "." as Knut
import "../lights" as Lights
import "../temperature" as Temperature

/*! \brief Displays the app's top bar.
 *
 *  The TopBar has a AnimatedIconButton on the left side which opends the
 *  backdrop of the TopBar. Beside that button is a TabBar to allow navigation
 *  in the app.
 */
Item {
    id: root

    /// Defines whether the backdrop is open or not
    property bool backdropOpen: false
    /// Size of the TabBar icon buttons
    property real buttonSize: 24
    /// The current TabBar index
    property alias currentIndex: bar.currentIndex

    implicitHeight: topItem.height + backdrop.height
    implicitWidth: Theme.referenceWidth

    Rectangle {
        id: background

        anchors.fill: parent

        color: Theme.background

        Rectangle { anchors.fill: parent; color: Theme.darkLayer }
    }

    Item {
        id: topItem

        implicitHeight: 56

        anchors {
            left: parent.left
            leftMargin: Theme.horizontalMargin
            right: parent.right
            rightMargin: Theme.horizontalMargin
            top: parent.top
        }

        Knut.AnimatedIconButton {
            id: backdropButton

            implicitHeight: parent.height
            implicitWidth: height

            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
            }

            bottomColor: Theme.foreground
            bottomSource: "../../images/icons/knut.svg"
            iconSize: root.buttonSize
            topColor: Theme.accent
            topSource: "../../images/icons/close.svg"

            Component.onCompleted: state = root.backdropOpen ? "top"
                                                             : "bottom"

            onClicked: root.backdropOpen = !root.backdropOpen
        }

        TabBar {
            id: bar

            implicitHeight: parent.height // root.buttonSize

            anchors {
                left: backdropButton.right
                right: parent.right
                verticalCenter: parent.verticalCenter
            }

            background: Rectangle { opacity: 0 }

            Repeater {
                model: ["../../images/icons/lamp.svg",
                        "../../images/icons/temperature.svg"]

                delegate: TabButton {
                    id: tabButton

                    anchors.verticalCenter: parent.verticalCenter

                    icon {
                        height: root.buttonSize

                        color: (bar.currentIndex === index) ? Theme.accent
                                                            : Theme.foreground
                        source: modelData
                    }

                    background: Rectangle { opacity: 0 }
                    opacity: bar.currentIndex === index ? 1.0 : Theme.opacity
                }
            }
        }
    }

    Item {
        id: backdrop

        implicitHeight: backdropColumn.height

        anchors {
            left: parent.left
            right: parent.right
            top: topItem.bottom
        }

        clip: true

        Column {
            id: backdropColumn

            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
            }

            bottomPadding: Theme.verticalMargin
            topPadding: Theme.verticalMargin

            Temperature.BackdropLocalWeather { width: parent.width }
            Lights.BackdropLightControl { width: parent.width }
        }
    }

    states: [
        State {
            name: "closed"
            when: !backdropOpen

            PropertyChanges {
                target: backdrop
                height: 0
            }
        },
        State {
            name: "open"
            when: backdropOpen

            PropertyChanges {
                target: backdrop
                height: implicitHeight
            }
        }
    ]

    transitions: [
        Transition {
            PropertyAnimation {
                duration: Theme.animationDuration
                easing.type: Easing.InOutCubic
                properties: "height"
                target: backdrop
            }
        }
    ]
}
