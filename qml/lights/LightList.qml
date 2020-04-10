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
