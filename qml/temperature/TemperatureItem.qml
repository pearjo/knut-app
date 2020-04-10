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

        color: root.state === "closed" ? Theme.background
                                       : Theme.backgroundElevated
    }

    MouseArea {
        id: extendButton

        anchors.fill: parent

        onClicked: {
            root.state = root.state === "closed" ? "opened" : "closed";
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

                    color: Theme.textForeground
                    elide: Text.ElideRight
                    font: Theme.fontSubtitle1
                    opacity: 0.5
                    text: {
                        if (!!temperature.condition) {
                            return ("<span style=\"font-family:Weather Icons;\">"
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

    FontLoader {
        id: weatherIconsFont
        source: "../../fonts/weather-icons/font/weathericons-regular-webfont.ttf"
    }

    onActiveFocusChanged: !activeFocus ? state = "closed" : undefined

    states: [
        State {
            name: "closed"

            PropertyChanges {
                target: root
                height: itemHeight
            }
        },
        State {
            name: "opened"

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
