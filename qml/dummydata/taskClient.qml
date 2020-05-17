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
import Knut 1.0
import QtQuick 2.14

Item {
    id: root

    // note that the remind signal is not included in this dummy item
    property alias taskModel: taskListModel

    function addTask(assignee, body, due, reminder, title) {
        taskListModel.append(
            {
                due: due,
                dueType: KnutTask.Today,
                task: {
                    done: false,
                    assignee: assignee,
                    author: "user",
                    body: body,
                    title: title,
                    due: due,
                    dueType: KnutTask.Today,
                    reminder: reminder,
                    uid: ""
                }
            }
        )
    }

    function deleteTask(task) {
        taskListModel.remove(task)
    }

    ListModel {
        id: taskListModel

        Component.onCompleted: {
            [
                {
                    due: new Date(Date.now() - 60000),
                    dueType: KnutTask.Today,
                    task: {
                        done: false,
                        assignee: "John",
                        author: "Bob",
                        body: "- [x] get some cheese at the supermarket.",
                        title: "Buy cheese",
                        due: new Date(Date.now() - 60000),
                        dueType: KnutTask.Today,
                        reminder: new Date(Date.now() - 65000),
                        uid: "12341"
                    }
                },
                {
                    due: new Date(Date.now() + 7200000), // due in two hours
                    dueType: KnutTask.Tomorrow,
                    task: {
                        done: false,
                        assignee: "Bob",
                        author: "Bob",
                        body: "- [x] get beer in supermarket.",
                        title: "Buy Beer",
                        due: new Date(Date.now() + 7200000), // due in two hours
                        dueType: KnutTask.Tomorrow,
                        reminder: new Date(Date.now() + 120000), // remind in two minutes
                        uid: "12342"
                    }
                },
            ].forEach(function(e) { append(e); });
        }
    }

    Timer {
        id: taskAddTimer

        interval: 5000
        repeat: false
        running: true

        onTriggered: addTask("Bob",
                             "get chips",
                             new Date(Date.now() + 60000),
                             new Date(Date.now() + 5000),
                             "Bring snacks")
    }
}
