import QtQuick 2.14

Item {
    id: root

    property real lightStateAll: 0.5

    property alias lightModel: lightListModel
    property alias roomModel: roomListModel

    ListModel {
        id: roomListModel

        Component.onCompleted: {
            [
                {
                    roomName: "Living Room",
                    room: {
                        roomName: "Living Room",
                        roomState: 0.5
                    }
                },
                {
                    roomName: "Bedroom",
                    room: {
                        roomName: "Bedroom",
                        roomState: 1
                    }
                }
            ].forEach(function(e) { append(e); });
        }
    }

    ListModel {
        id: lightListModel

        Component.onCompleted: {
            [
                {
                    room: "Bedroom",
                    light: {
                        hasColor: true,
                        hasDimlevel: true,
                        hasTemperature: true,
                        lightState: true,
                        dimlevel: 10.0,
                        temperature: 1.0,
                        colorCold: "#F5FAF6",
                        colorWarm: "#EFD275",
                        lightColor: "#EFD275",
                        location: "Shelf",
                        room: "Bedroom"
                    }
                },
                {
                    room: "Living Room",
                    light: {
                        hasColor: false,
                        hasDimlevel: true,
                        hasTemperature: false,
                        lightState: false,
                        dimlevel: 0.0,
                        temperature: 0,
                        colorCold: "#F5FAF6",
                        colorWarm: "#EFD275",
                        lightColor: "#EFD275",
                        location: "Sofa",
                        room: "Living Room"
                    }
                },
                {
                    room: "Living Room",
                    light: {
                        hasColor: false,
                        hasDimlevel: false,
                        hasTemperature: false,
                        lightState: false,
                        dimlevel: 0,
                        temperature: 0,
                        colorCold: "#F5FAF6",
                        colorWarm: "#EFD275",
                        lightColor: "#EFD275",
                        location: "TV",
                        room: "Living Room"
                    }
                }
            ].forEach(function(e) { append(e); });
        }
    }
}
