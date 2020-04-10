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
import QtQml.Models 2.14
import QtQuick 2.14

Item {
    id: root

    property alias localWeather: localWeather
    property alias temperatureModel: temperatureListModel

    function timeHistoryToday(length) {
        var timeHistoryArray = [];
        var today = new Date();
        for (var i = 0; i < length; i++) {
            timeHistoryArray[i] = new Date(today.getFullYear(),
                                           today.getMonth(),
                                           today.getDate(),
                                           i);
        }

        return timeHistoryArray;
    }

    ListModel {
        id: temperatureListModel

        Component.onCompleted: {
            [
                {
                    temperature: {
                        temperature: 5.3,
                        condition: "\uf00d",
                        location: "Hamburg",
                        unit: "°C",
                        temperatureHistory: [
                            5.830000000000041,
                            4.910000000000025,
                            4.03000000000003,
                            3.5100000000000477,
                            3.490000000000009,
                            3.5300000000000296,
                            2.5500000000000114,
                            1.7200000000000273,
                            1.3000000000000114,
                            1.4800000000000182,
                            1.920000000000016,
                            3.080000000000041,
                            3.9500000000000455,
                            4.180000000000007,
                            5.150000000000034,
                            5.270000000000039
                        ],
                        timeHistory: timeHistoryToday(16) // lenght of temperatureHistory
                    }
                },
                {
                    temperature: {
                        temperature: 25.3,
                        condition: "\uf00d",
                        location: "Los Angeles",
                        unit: "°C",
                        temperatureHistory: [
                            25.830000000000041,
                            24.910000000000025,
                            24.03000000000003,
                            23.5100000000000477,
                            23.490000000000009,
                            23.5300000000000296,
                            22.5500000000000114,
                            21.7200000000000273,
                            21.3000000000000114,
                            21.4800000000000182,
                            21.920000000000016,
                            23.080000000000041,
                            23.9500000000000455,
                            24.180000000000007,
                            25.150000000000034,
                            25.270000000000039
                        ],
                        timeHistory: timeHistoryToday(16) // lenght of temperatureHistory
                    }
                }
            ].forEach(function(e) { append(e); });
        }
    }

    QtObject {
        id: localWeather

        property real temperature: 5.3
        property string condition: "\uf00d"
        property string location: "Hamburg"
        property string unit: "°C"
        property var temperatureHistory: [
            5.830000000000041,
            4.910000000000025,
            4.03000000000003,
            3.5100000000000477,
            3.490000000000009,
            3.5300000000000296,
            2.5500000000000114,
            1.7200000000000273,
            1.3000000000000114,
            1.4800000000000182,
            1.920000000000016,
            3.080000000000041,
            3.9500000000000455,
            4.180000000000007,
            5.150000000000034,
            5.270000000000039
        ]
        property var timeHistory: timeHistoryToday(16) // lenght of temperatureHistory
    }
}
