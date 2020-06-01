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
import Knut.Controls 1.0 as Knut
import Knut.Theme 1.0
import QtGraphicalEffects 1.14
import QtQuick 2.14
import QtQuick.Controls 2.14

import "lights" as Lights
import "screens" as Screens
import "tasks" as Tasks
import "temperature" as Temperature

ApplicationWindow {
    id: app

    height: Theme.referenceHeight
    width: Theme.referenceWidth

    color: "#000000"
    title: qsTr("Knut")
    visible: true

    SwipeView {
        id: swipeView

        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: topBar.top
        }

        background: Rectangle { color: Theme.background }
        clip: true
        currentIndex: topBar.currentIndex
        enabled: !backdrop.isOpen

        Lights.LightList {}
        Temperature.TemperatureList {}
        Tasks.TaskList {}
    }

    Knut.ModalBackground {
        id: blurBackground

        anchors.fill: swipeView

        opacity: backdrop.isOpen ? 1 : 0
        source: swipeView
    }

    Screens.Backdrop {
        id: backdrop

        anchors {
            left: parent.left
            right: parent.right
            bottom: topBar.top
        }

        isOpen: topBar.backdropOpen
    }

    Screens.TopBar {
        id: topBar

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        currentIndex: swipeView.currentIndex
        model: ["../../images/icons/lamp.svg",
                "../../images/icons/temperature.svg",
                "../../images/icons/task.svg"]
    }

    Screens.LoadingScreen { id: loadingScreen; anchors.fill: parent }
    Screens.LoginScreen { id: loginScreen; anchors.fill: parent }
}
