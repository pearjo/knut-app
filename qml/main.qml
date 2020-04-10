import QtGraphicalEffects 1.14
import QtQuick 2.14
import QtQuick.Controls 2.14

import "knut" as Knut
import "lights" as Lights
import "screens" as Screens
import "temperature" as Temperature

import Theme 1.0

ApplicationWindow {
    id: app

    height: Theme.referenceHeight
    width: Theme.referenceWidth

    color: Theme.background
    title: qsTr("Knut")
    visible: true

    Knut.TopBar {
        id: topBar

        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }

        currentIndex: swipeView.currentIndex
    }

    SwipeView {
        id: swipeView

        anchors {
            left: parent.left
            right: parent.right
            top: topBar.bottom
            bottom: parent.bottom
        }

        background: Rectangle { color: Theme.background }
        clip: true
        currentIndex: topBar.currentIndex

        Lights.LightList {}
        Temperature.TemperatureList {}
    }

    Screens.LoadingScreen { id: loadingScreen; anchors.fill: parent }
    Screens.LoginScreen { id: loginScreen; anchors.fill: parent }
}
