import QtQuick 2.14
import QtQuick.Controls 2.14

import Theme 1.0

import "." as Knut

/*! \brief Displays an animated icon button.
 *
 *  The button has a top and bottom icon. If for example, the top icon is
 *  visible and the button clicked, the top icon will slide out to the top of
 *  the visible button area and the bottom icon will slide in from the bottom.
 */
MouseArea {
    id: root

    //! The icon color.
    property color color
    /*! If not set, the icon has the size of the button height. By setting an
     *  \a iconSize, the icon can be smaller while the active mouse area is
     *  still bigger.
     */
    property real iconSize

    //! Overrides \a color for the bottom icon.
    property alias bottomColor: bottomIcon.color
    //! The URL to the bottom icon graphic.
    property alias bottomSource: bottomIcon.source
    //! Overrides \a color for the top icon.
    property alias topColor: topIcon.color
    //! The URL to the top icon graphic.
    property alias topSource: topIcon.source

    implicitHeight: 36
    implicitWidth: 36

    Item {
        id: icon

        height: !!root.iconSize ? root.iconSize : root.height
        width: height

        anchors.centerIn: parent

        clip: true

        Column {
            id: iconColumn

            height: 2 * parent.hight
            width: parent.width

            Knut.ColorIcon {
                id: topIcon

                height: !!root.iconSize ? root.iconSize : root.height

                anchors {
                    left: parent.left
                    right: parent.right
                }

                color: root.color
            }

            Knut.ColorIcon {
                id: bottomIcon

                height: !!root.iconSize ? root.iconSize : root.height

                anchors {
                    left: parent.left
                    right: parent.right
                }

                color: root.color
            }
        }
    }

    onClicked: state = state === "top" ? "bottom" : "top"

    states: [
        State {
            name: "bottom"

            AnchorChanges {
                target: iconColumn
                anchors {
                    bottom: parent.bottom
                    top: undefined
                }
            }
        },
        State {
            name: "top"

            AnchorChanges {
                target: iconColumn
                anchors {
                    bottom: undefined
                    top: parent.top
                }
            }
        }
    ]

    transitions: [
        Transition {
            from: "bottom"
            to: "top"
            /* target: iconColumn */

            AnchorAnimation {
                duration: Theme.animationDuration
                easing.type: Easing.InOutCubic
            }
        },
        Transition {
            from: "top"
            to: "bottom"
            /* target: iconColumn */

            AnchorAnimation {
                duration: Theme.animationDuration
                easing.type: Easing.InOutCubic
            }
        }
    ]
}
