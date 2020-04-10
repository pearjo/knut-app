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

QtObject {
    property bool hasColor: true
    property bool hasDimlevel: true
    property bool hasTemperature: true
    property bool lightState: false
    property real dimlevel: 0.0
    property real temperature: 1.0
    property string colorCold: "#F5FAF6"
    property string colorWarm: "#EFD275"
    property string lightColor: "#EFD275"
    property string location: "Sofa"
    property string room: "Living Room"

    // mock the dimlevel when changing the state
    onLightStateChanged: dimlevel = lightState ? 50 : 0
}
