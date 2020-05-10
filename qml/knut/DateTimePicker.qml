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
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14
import QtGraphicalEffects 1.14
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQml 2.14

import Theme 1.0

import "." as Task
import "../knut" as Knut

//! A popup to pick a date and time.
Item {
    id: dateTimePicker

    //! This property holds the title text of the \a DateTimePicker.
    property string title: qsTr("Select a time")

    /*! This property holds the pre-selected date. If undefined, the current
     *  date is selected.
     */
    property var date: new Date()

    //! Emitted when the date is selected by pressing the check button.
    signal dateTimeSelected(var selectedDate)

    implicitHeight: rootColumn.height
    implicitWidth: 0.8 * Theme.referenceWidth

    Rectangle {
        id: background

        anchors.fill: parent

        color: Theme.background
        radius: Theme.radius
        opacity: Theme.opacity
    }

    Column {
        id: rootColumn

        anchors {
            left: parent.left
            right: parent.right
            leftMargin: Theme.horizontalMargin
            rightMargin: Theme.horizontalMargin
        }

        topPadding: Theme.verticalMargin
        bottomPadding: Theme.verticalMargin + applyButton.height / 2
        spacing: Theme.verticalItemSpace

        Text {
            id: titleText

            height: 36
            width: parent.width

            color: Theme.textAccent
            font: Theme.fontH6
            text: dateTimePicker.title
            verticalAlignment: Text.AlignVCenter
        }

        Text {
            id: editDateText

            height: contentHeight
            width: parent.width

            color: Theme.textAccent
            font: Theme.fontCaption
            text: qsTr("Date")
            verticalAlignment: Text.AlignVCenter
        }

        Calendar {
            id: datePicker

            anchors {
                left: parent.left
                right: parent.right
                leftMargin: Theme.horizontalMargin
                rightMargin: Theme.horizontalMargin
            }

            frameVisible: false
            selectedDate: dateTimePicker.date

            style: CalendarStyle {
                gridVisible: false

                background: Rectangle {
                    implicitHeight: parent.width

                    anchors {
                        left: parent.left
                        right: parent.right
                    }

                    color: "transparent"
                }

                dayDelegate: Rectangle {
                    color: "transparent"

                    Label {
                        anchors.centerIn: parent

                        color: styleData.selected ? Theme.textAccent :
                               styleData.visibleMonth ? Theme.textForeground :
                               Theme.textDisabled
                        font: Theme.fontBody2
                        text: styleData.date.getDate()
                    }
                }

                dayOfWeekDelegate: Rectangle {
                    color: "transparent"

                    implicitHeight: 28

                    Label {
                        anchors.centerIn: parent

                        color: Theme.textAccent
                        font: Theme.fontCaption
                        text: Qt.locale().dayName(styleData.dayOfWeek,
                                                  Locale.ShortFormat)
                    }
                }

                navigationBar: Rectangle {
                    height: 28

                    anchors {
                        left: parent.left
                        right: parent.right
                    }

                    color: "transparent"

                    Knut.ToggleButton {
                        id: previousButton

                        anchors {
                            left: parent.left
                            verticalCenter: parent.verticalCenter
                        }

                        source: "../../images/icons/other/material/navigate_before-24px.svg"

                        onClicked: datePicker.showPreviousMonth()
                    }

                    Knut.ToggleButton {
                        id: nextButton

                        anchors {
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                        }

                        source: "../../images/icons/other/material/navigate_next-24px.svg"

                        onClicked: datePicker.showNextMonth()
                    }

                    Text {
                        anchors.centerIn: parent

                        color: Theme.textForeground
                        font: Theme.fontButton
                        text: styleData.title
                    }
                }
            }
        }

        Text {
            id: editTimeText

            height: contentHeight
            width: parent.width

            color: Theme.textAccent
            font: Theme.fontCaption
            text: qsTr("Time")
            verticalAlignment: Text.AlignVCenter
        }

        Component {
            id: delegateComponent

            Label {
                color: Theme.textForeground
                font: Theme.fontBody1
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                opacity: (1.0 - Math.abs(Tumbler.displacement)
                          / (Tumbler.tumbler.visibleItemCount / 2))
                text: modelData.toString().length < 2 ? "0" + modelData
                                                      : modelData
            }
        }

        Row {
            id: row

            width: childrenRect.width
            height: childrenRect.height

            anchors.horizontalCenter: parent.horizontalCenter

            Tumbler {
                id: hoursTumbler

                height: 152

                currentIndex: dateTimePicker.date.getHours()
                delegate: delegateComponent
                model: 24
            }

            Tumbler {
                id: minutesTumbler

                height: 152

                currentIndex: dateTimePicker.date.getMinutes()
                delegate: delegateComponent
                model: 60
            }
        }
    }

    Knut.ActionButton {
        id: applyButton

        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.bottom
        }

        source: "../../images/icons/other/material/check-24px.svg"

        onClicked: {
            var selectedDate = datePicker.selectedDate;
            selectedDate.setHours(hoursTumbler.currentIndex,
                                  minutesTumbler.currentIndex,
                                  0);
            dateTimePicker.dateTimeSelected(selectedDate);
        }
    }
}
