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
import QtQml 2.14
import QtQuick 2.14

Item {
    id: root

    property bool connected: false
    property int port: 8080
    property string hostAddress: ""

    //! Timer to mock the loading process of the KnutClient
    Timer {
        interval: 2000
        repeat: false
        running: true

        onTriggered: root.connected = !root.connected
    }
}
