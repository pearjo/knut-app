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
import QtCharts 2.14
import QtGraphicalEffects 1.14
import QtQuick 2.14
import QtQuick.Controls 2.14

import Theme 1.0

import "../knut" as Knut

/*!
 * \brief Displays a temperature item
 * \inherits Item
 * \qmltype Temperature
 */
FocusScope {
    id: root

    /* internal property describing whether the control is extended or not */
    property bool __isOpen: false

    /// Knut \a Light object which should be controlled
    property var temperature: localWeather

    readonly property real itemHeight: 76
    readonly property string info: ("<font size=\"1\">min</font> "
                                    + Math.min(...temperature.temperatureHistory).toFixed(1)
                                    + "\u202f" // narrow form of a no-break space
                                    + temperature.unit
                                    + ", <font size=\"1\">max</font> "
                                    + Math.max(...temperature.temperatureHistory).toFixed(1)
                                    + "\u202f" // narrow form of a no-break space
                                    + temperature.unit)
    readonly property var today: new Date()

    implicitHeight: rootColumn.height
    implicitWidth: Theme.referenceWidth

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
                                        - 2 * Theme.horizontalMargin)

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
                    text: temperature.location
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
                    text: {
                        if (!!temperature.condition) {
                            return ("<span style=\"font-family:"
                                    + Theme.typefaceWeatherIcon.name
                                    + ";\">"
                                    + temperature.condition
                                    + "</span> • "
                                    + root.info)
                        } else {
                            return root.info
                        }
                    }
                    textFormat: Text.RichText
                }
            }

            Text {
                id: valueText

                anchors {
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }

                color: Theme.textAccent
                elide: Text.ElideRight
                font: Theme.fontH5
                text: ("<font color=\"" + Theme.textForeground + "\">"
                       + temperature.temperature.toFixed(1) + "</font>"
                       + "\u202f" // narrow form of a no-break space
                       + "<font size=\"2\">"
                       + temperature.unit + "</font>")
            }
        }

        ChartView {
            id: temperatureChart

            implicitHeight: 260

            anchors {
                left: parent.left
                right: parent.right
            }

            function updateSeries() {
                var i = splineSeries.count;

                if (!!root.temperature.timeHistory) {
                    for (i; i < root.temperature.timeHistory.length; i++) {
                        splineSeries.append(root.temperature.timeHistory[i],
                                            root.temperature.temperatureHistory[i]);
                    }
                }
            }

            antialiasing: true
            backgroundColor: "transparent"
            backgroundRoundness: 0
            legend.visible: false

            Component.onCompleted: updateSeries();

            SplineSeries {
                id: splineSeries

                capStyle: Qt.RoundCap
                color: Theme.accent

                axisX: DateTimeAxis {
                    color: Theme.background
                    format: "hh:mm"
                    gridVisible: false
                    labelsColor: Theme.textForeground
                    labelsFont: Theme.fontCaption

                    max: new Date(root.today.getFullYear(),
                                  root.today.getMonth(),
                                  root.today.getDate(),
                                  24);
                    min: new Date(root.today.getFullYear(),
                                  root.today.getMonth(),
                                  root.today.getDate(),
                                  0);
                }
                axisY: ValueAxis {
                    color: Theme.background
                    gridLineColor: Theme.background
                    gridVisible: true
                    labelFormat: "%.1f"
                    labelsColor: Theme.textForeground
                    labelsFont: Theme.fontCaption
                    titleText: ("<font color=\""
                                + Theme.textAccent
                                + "\">"
                                + root.temperature.unit
                                + "</font>")
                    titleFont: Theme.fontButton

                    max: Math.max(...root.temperature.temperatureHistory) + 1
                    min: Math.min(...root.temperature.temperatureHistory) - 1
                }
            }
        }
    }

    Connections {
        target: temperature
        onTimeHistoryChanged: temperatureChart.updateSeries()
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
