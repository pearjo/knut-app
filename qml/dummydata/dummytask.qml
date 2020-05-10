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
import Knut 1.0

QtObject {
    id: root

    property bool done: false
    property string assignee: "John"
    property string author: "Bob"
    property string body: "- [x] get some cheese at the supermarket."
    property string title: "Buy cheese"
    property var due: new Date(Date.now() + 60000) // due in one minute
    property int dueType: KnutTask.Today
    property var reminder: new Date(Date.now() + 5000) // remind in 5 seconds
    readonly property string uid: "12345"

    signal remind
}
