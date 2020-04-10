import QtQuick 2.14

import Theme 1.0

import "." as Temperature
import "../knut" as Knut

ListView {
    id: root

    implicitHeight: Theme.referenceHeight
    implicitWidth: Theme.referenceWidth

    model: !!temperatureClient ? temperatureClient.temperatureModel : undefined

    delegate: Temperature.TemperatureItem {
        anchors {
            left: parent.left
            right: parent.right
        }

        temperature: model.temperature
    }

    header: Knut.ListViewHeader {
        anchors {
            left: parent.left
            right: parent.right
        }

        title: qsTr("Temperatures")
    }
}
