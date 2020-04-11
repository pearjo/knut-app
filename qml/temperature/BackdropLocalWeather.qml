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

import "../knut" as Knut

Item {
    id: root

    implicitHeight: 72
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

        color: Theme.backgroundElevated
        radius: Theme.radius

        Text {
            id: conditionIcon

            height: 40
            width: height

            anchors {
                left: parent.left
                leftMargin: Theme.horizontalMargin / 2
                verticalCenter: parent.verticalCenter
            }

            font.family: Theme.typefaceWeatherIcon.name
            font.pixelSize: 24
            horizontalAlignment: Text.AlignHCenter
            text: temperatureClient.localWeather.condition
            verticalAlignment: Text.AlignVCenter
            color: Theme.accent
        }

        Text {
            id: cityText

            anchors {
                left: conditionIcon.right
                leftMargin: Theme.horizontalItemSpace
                verticalCenter: parent.verticalCenter
            }

            color: Theme.textAccent
            elide: Text.ElideRight
            font: Theme.fontH5
            text: temperatureClient.localWeather.location
        }

        Text {
            id: valueText

            anchors {
                right: parent.right
                rightMargin: Theme.horizontalMargin / 2
                verticalCenter: parent.verticalCenter
            }

            color: Theme.textAccent
            elide: Text.ElideRight
            font: Theme.fontH5
            text: ("<font color=\"" + Theme.textForeground + "\">"
                   + temperatureClient.localWeather.temperature.toFixed(1)
                   + "</font>"
                   + "\u202f" // narrow form of a no-break space
                   + "<font size=\"2\">"
                   + temperatureClient.localWeather.unit + "</font>")
        }
    }
}
