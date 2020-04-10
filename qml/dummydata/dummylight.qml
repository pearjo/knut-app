import QtQuick 2.14

QtObject {
    property bool hasColor: true
    property bool hasDimlevel: true
    property bool hasTemperature: true
    property bool lightState: false
    property real dimlevel: 0.0
    property real temperature: 1.0
    property string colorCold: "#F5FAF6"
    property string colorWarm: "#EFD275"
    property string lightColor: "#EFD275"
    property string location: "Sofa"
    property string room: "Living Room"

    // mock the dimlevel when changing the state
    onLightStateChanged: dimlevel = lightState ? 50 : 0
}
