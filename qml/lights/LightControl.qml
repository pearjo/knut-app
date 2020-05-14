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
import QtGraphicalEffects 1.14
import QtQuick 2.14
import QtQuick.Controls 2.14

import Theme 1.0

import "../knut" as Knut

/*! \brief Displays an Item to control a Light.
 *
 *  If the Light is either dim-able, has a changeable color temperature
 *  or editable color, the control expands when tapping it.
 */
FocusScope {
    id: root

    /* internal property describing whether the control is extended or not */
    property bool __isOpen: false

    //! A Knut \a Light service to be controlled.
    property var light: dummylight

    //! Height of the Light control when it is not extended.
    readonly property real itemHeight: 76
    //! Info text displayed in the control.
    readonly property string info: {
        if (!!dimlevelSlider.visualPosition) {
            return (light.room
                    + " • "
                    + Math.round(dimlevelSlider.visualPosition * 100)
                    + " %")
        } else {
            return light.room
        }
    }

    /*! Interpolates between a \a cold and \a warm color for a \a value which is
     *  in the range \c 0 to \c 1.
     *
     *  \param type:string cold The color hex code of the cold color
     *  \param type:string warm The color hex code of the warm color
     *  \param type:real value The value to interpolate to in the range \c 0
     *                         to \c 1 where 0 is cold and 1 is warm
     *  \returns type:string The interpolated color hex code
     */
    function getTemperature(cold, warm, value) {
        var coldH = + cold.replace('#', '0x'),
            coldR = coldH >> 16, coldG = coldH >> 8 & 0xff, coldB = coldH & 0xff,
            warmH = + warm.replace('#', '0x') ,
            warmR = warmH >> 16, warmG = warmH >> 8 & 0xff, warmB = warmH & 0xff,
            temperatureR = coldR + value * (warmR - coldR),
            temperatureG = coldG + value * (warmG - coldG),
            temperatureB = coldB + value * (warmB - coldB);

        return '#' + ((1 << 24) + (temperatureR << 16) + (temperatureG << 8)
                      + temperatureB | 0).toString(16).slice(1);
    }

    implicitHeight: rootColumn.height
    implicitWidth: 320

    clip: true
    state: "closed"

    Rectangle {
        id: background

        anchors.fill: parent

        color: __isOpen ? Theme.backgroundElevated : Theme.background
    }

    MouseArea {
        id: extendButton

        anchors.fill: parent

        onClicked: {
            if (light.hasDimlevel || light.hasTemperature)
                __isOpen = !__isOpen;
            root.forceActiveFocus();
        }
    }

    Column {
        id: rootColumn

        height: childrenRect.height
        width: parent.width

        Item {
            id: topItem

            height: itemHeight

            anchors {
                left: parent.left
                leftMargin: Theme.horizontalMargin
                right: parent.right
                rightMargin: Theme.horizontalMargin
            }

            Item {
                id: descriptionItem

                implicitHeight: childrenRect.height
                implicitWidth: Math.min(parent.width * 0.5,
                                        parent.width
                                        - 2 * Theme.horizontalMargin
                                        - triSwitch.width)

                anchors {
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                }

                Text {
                    id: locationText

                    height: contentHeight
                    width: parent.width

                    anchors {
                        left: parent.left
                        top: parent.top
                    }

                    color: Theme.textForeground
                    elide: Text.ElideRight
                    font: Theme.fontH6
                    text: light.location
                }

                Text {
                    id: infoText

                    height: contentHeight
                    width: parent.width

                    anchors {
                        left: parent.left
                        top: locationText.bottom
                        topMargin: Theme.verticalMargin
                    }

                    color: __isOpen ? Theme.textForeground : Theme.textDisabled
                    elide: Text.ElideRight
                    font: Theme.fontSubtitle1
                    text: info
                }
            }

            Knut.TriSwitch {
                id: triSwitch

                anchors {
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }

                value: light.lightState ? 1 : 0

                onClicked: light.lightState = boolValue
            }
        }

        Item {
            id: dimlevelItem

            implicitHeight: itemHeight

            anchors {
                left: parent.left
                right: parent.right
            }

            clip: true
            visible: light.hasDimlevel

            Text {
                id: dimlevelLeftText

                anchors {
                    right: dimlevelSlider.left
                    rightMargin: Theme.horizontalMargin
                    verticalCenter: dimlevelSlider.verticalCenter
                }

                color: Theme.textForeground
                font: Theme.fontButton
                opacity: 0.8
                text: qsTr("Dark")
            }

            Text {
                id: dimlevelRightText

                anchors {
                    left: dimlevelSlider.right
                    leftMargin: Theme.horizontalMargin
                    verticalCenter: dimlevelSlider.verticalCenter
                }

                color: Theme.textForeground
                font: Theme.fontButton
                opacity: 0.8
                text: qsTr("Bright")
            }

            Knut.Slider {
                id: dimlevelSlider

                width: 160

                anchors.centerIn: parent

                from: 0
                live: false
                stepSize: 1
                to: 100
                value: light.dimlevel

                onReleased: light.dimlevel = value
            }

            Knut.ColorIcon {
                id: lampIcon

                anchors {
                    left: parent.left
                    leftMargin: Theme.horizontalMargin
                    verticalCenter: dimlevelSlider.verticalCenter
                }

                color: Theme.accent
                opacity: Math.max(dimlevelSlider.visualPosition, 0.1)
                source: "../../images/icons/lamp.svg"
                visible: parent.width > 400
            }
        }

        Item {
            id: temperatureItem

            implicitHeight: itemHeight

            anchors {
                left: parent.left
                right: parent.right
            }

            Rectangle {
                id: temperatureIcon

                height: 38
                width: height

                anchors {
                    left: parent.left
                    leftMargin: Theme.horizontalMargin
                    verticalCenter: temperatureSlider.verticalCenter
                }

                color: getTemperature(light.colorCold,
                                      light.colorWarm,
                                      temperatureSlider.visualPosition)
                radius: height / 2
                visible: parent.width > 400
            }

            clip: true
            visible: light.hasTemperature

            DropShadow {
                id: temperatureIconShadow

                anchors.fill: temperatureIcon

                color: Theme.shadowColor
                horizontalOffset: Theme.shadowHorizontalOffset
                radius: Theme.shadowRadius
                samples: Theme.shadowSamples
                source: temperatureIcon
                verticalOffset: Theme.shadowVerticalOffset
                visible: parent.width > 400
            }

            Text {
                id: temperatureLeftText

                anchors {
                    right: temperatureSlider.left
                    rightMargin: Theme.horizontalMargin
                    verticalCenter: temperatureSlider.verticalCenter
                }

                color: Theme.textForeground
                font: Theme.fontButton
                opacity: 0.8
                text: qsTr("Cold")
            }

            Text {
                id: temperatureRightText

                anchors {
                    left: temperatureSlider.right
                    leftMargin: Theme.horizontalMargin
                    verticalCenter: temperatureSlider.verticalCenter
                }

                color: Theme.textForeground
                font: Theme.fontButton
                opacity: 0.8
                text: qsTr("Warm")
            }

            Knut.Slider {
                id: temperatureSlider

                width: 160

                anchors.centerIn: parent

                from: 0
                live: false
                stepSize: 1
                to: 100

                value: light.temperature

                onReleased: light.temperature = value
            }
        }

    }

    onActiveFocusChanged: !activeFocus ? __isOpen = false : undefined

    states: [
        State {
            name: "closed"
            when: !__isOpen

            PropertyChanges {
                target: root
                height: itemHeight
            }
        },
        State {
            name: "opened"
            when: __isOpen

            PropertyChanges {
                target: root
                height: implicitHeight
            }
        }
    ]

    Behavior on height {
        NumberAnimation {
            duration: Theme.animationDuration
            easing.type: Easing.OutCubic
        }
    }
}
