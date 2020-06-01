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
import Knut.Controls 1.0 as Knut
import Knut.Theme 1.0
import QtQuick 2.14
import QtQuick.Controls 2.14

//! A bullet journal like toggle button.
Control {
    id: root

    // internal property used for toggling
    property bool __done

    //! This property is true if the task is done.
    property bool done: false

    //! This property defines the color of the bullet.
    property color color: Theme.foreground

    //! Emitted whenever the bullet is clicked.
    signal clicked

    implicitHeight: 48
    implicitWidth: 48

    onDoneChanged: {
        if (done !== __done)
            __done = done;
    }

    Binding {
        property: "done"
        target: root
        value: root.__done
    }

    MouseArea {
        id: button

        anchors.fill: parent

        Knut.ColorIcon {
            id: doneBullet

            height: 28
            width: root.done ? height : 0

            anchors.centerIn: parent

            color: root.color
            source: "../../images/icons/close.svg"

            Behavior on width {
                NumberAnimation {
                    duration: Theme.animationDuration
                    easing.type: root.done ? Easing.OutQuint : Easing.InQuint
                }
            }
        }

        Rectangle {
            id: incomleteBullet

            height: 10
            width: root.__done ? 0 : height

            anchors.centerIn: parent

            color: root.color
            radius: 0.5 * height
            visible: !root.__done

            Behavior on width {
                NumberAnimation {
                    duration: Theme.animationDuration
                    easing.type: root.__done ? Easing.InQuint : Easing.OutQuint
                }
            }
        }

        onClicked: {
            __done = !__done;
            root.clicked();
        }
    }
}
