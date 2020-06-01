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

import "." as Temperature

ListView {
    id: root

    implicitHeight: Theme.referenceHeight
    implicitWidth: Theme.referenceWidth

    model: !!temperatureClient ? temperatureClient.temperatureModel : undefined

    delegate: Temperature.TemperatureItem {
        anchors {
            left: parent.left
            right: parent.right
        }

        temperature: model.temperature
    }

    header: Knut.ListViewHeader {
        anchors {
            left: parent.left
            right: parent.right
        }

        title: qsTr("Temperatures")
    }
}
