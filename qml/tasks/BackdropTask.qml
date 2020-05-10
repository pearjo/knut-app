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

import "." as Task
import "../knut" as Knut

Item {
    id: root

    //! Returns a formatted \a unit string.
    function unitString(unit) {
        return ("\u202f" // narrow form of a no-break space
                + "<font size=\"2\" color=\"" + Theme.textAccent + "\">"
                + unit
                + "</font>");
    }

    implicitHeight: taskList.height > 0 ? upcomingColumn.height : 0
    implicitWidth: Theme.referenceWidth

    visible: implicitHeight > 0

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
    }

    Column {
        id: upcomingColumn

        anchors {
            left: background.left
            leftMargin: Theme.horizontalMargin / 2
            right: background.right
            rightMargin: Theme.horizontalMargin / 2
        }

        bottomPadding: Theme.verticalMargin
        topPadding: Theme.verticalMargin

        Item {
            id: header

            height: 56
            width: parent.width

            Knut.ColorIcon {
                id: headerIcon

                anchors.verticalCenter: parent.verticalCenter

                source: "../../images/icons/task.svg"
                color: Theme.accent
            }

            Text {
                id: headerText

                height: contentHeight
                width: contentWidth

                anchors {
                    left: headerIcon.right
                    verticalCenter: parent.verticalCenter
                    leftMargin: Theme.horizontalItemSpace
                }

                verticalAlignment: Text.AlignVCenter
                color: Theme.textAccent
                font: Theme.fontH5
                text: qsTr("Tasks")
            }
        }

        ListView {
            id: taskList

            height: childrenRect.height
            width: parent.width

            model: taskClient.taskModel

            delegate: Item{

                height: model.task.reminder < knutHelper.time && !model.task.done ? 36 : 0
                width: parent.width

                clip: true

                Text {
                    id: titleText

                    height: parent.height
                    width: 0.8 * parent.width

                    anchors.left: parent.left

                    verticalAlignment: Text.AlignVCenter
                    color: Theme.textForeground
                    elide: Text.ElideRight
                    font: Theme.fontH6
                    text: model.task.title
                }

                Text {
                    id: countdownText

                    readonly property var secsToDue: (model.task.due
                                                      - knutHelper.time) / 1000

                    height: parent.height
                    width: 0.2 * parent.width

                    anchors.right: parent.right

                    color: Theme.textForeground
                    font: Theme.fontH6
                    horizontalAlignment: Text.AlignRight
                    text: {
                        if (secsToDue > 86400) {
                            var days = Math.floor(secsToDue / 86400);
                            return (days
                                    + unitString(qsTr(days > 1 ? "days"
                                                               : "day")));
                        } else if (secsToDue > 3600) {
                            return (knutHelper.toStringFromSecs(secsToDue,
                                                                "h:mm")
                                    + unitString(qsTr("hr")));
                        } else if (secsToDue >= 60) {
                            return (knutHelper.toStringFromSecs(secsToDue, "m")
                                    + unitString(qsTr("min")));
                        } else {
                            return (knutHelper.toStringFromSecs(secsToDue, "s")
                                    + unitString(qsTr("s")));
                        }
                    }
                    verticalAlignment: Text.AlignVCenter
                    visible: knutHelper.time < model.task.due
                }

                Text {
                    id: overdueText

                    width: contentWidth

                    anchors {
                        left: parent.right
                        verticalCenter: parent.verticalCenter
                    }

                    color: Theme.textAccent
                    font: Theme.fontH6
                    horizontalAlignment: Text.AlignRight
                    text: qsTr("Overdue")
                    verticalAlignment: Text.AlignVCenter


                    states: State {
                        name: "overdue"
                        when: knutHelper.time > model.task.due

                        AnchorChanges {
                            target: overdueText
                            anchors {
                                left: undefined
                                right: parent.right
                            }
                        }
                    }

                    transitions: Transition {
                        to: "overdue"

                        AnchorAnimation {
                            duration: 2000
                            easing.type: Easing.OutElastic
                        }
                    }
                }
            }
        }
    }

    Behavior on implicitHeight {
        NumberAnimation {
            duration: Theme.animationDuration
            easing.type: Easing.OutCubic
        }
    }
}
