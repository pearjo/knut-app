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

Item {
    id: root

    property var time: new Date()

    //! Returns the Date \a dateTime as string in the \a format.
    function formatDateTime(dateTime, format) {
        // \todo implement dummy method
        return "";
    }

    //! Returns a time \a string like hh, mm or ss with a leading zero.
    function leadingZero(string) {
        return string.length < 2 ? "0" + string : string;
    }

    //! Returns the seconds \a s as string in the \a format.
    function toStringFromSecs(s, format) {
        var hours = Math.floor(s / 3600);
        var minutes = Math.floor((s % 3600) / 60);
        var seconds = Math.ceil((s % 3600) % 60);

        var string;

        switch (format) {
        case "h:mm":
            string = hours.toString() + ":" + leadingZero(minutes.toString());
            break;
        case "m":
            string = minutes.toString();
            break;
        case "s":
            string = seconds.toString();
            break;
        default:
            string = "";
        }

        return string;
    }

    Timer {
        id: timer

        interval: 1000
        repeat: true
        running: true
        triggeredOnStart: true

        onTriggered: time = new Date()
    }
}
