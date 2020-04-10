import QtQml 2.14
import QtQuick 2.14

Item {
    id: root

    property bool connected: false
    property int port: 8080
    property string hostAddress: ""

    //! Timer to mock the loading process of the KnutClient
    Timer {
        interval: 2000
        repeat: false
        running: true

        onTriggered: root.connected = !root.connected
    }
}
