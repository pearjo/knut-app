import QtQuick 2.14

QtObject {
    id: root

    readonly property real temperature: 20.3
    readonly property string condition: "\uf00d"
    readonly property string location: "Hamburg"
    readonly property string unit: "°C"
    readonly property var temperatureHistory: [
        5.830000000000041,
        4.910000000000025,
        4.03000000000003,
        3.5100000000000477,
        3.490000000000009,
        3.5300000000000296,
        2.5500000000000114,
        1.7200000000000273,
        1.3000000000000114,
        1.4800000000000182,
        1.920000000000016,
        3.080000000000041,
        3.9500000000000455,
        4.180000000000007,
        5.150000000000034,
        5.270000000000039
    ]
    readonly property var timeHistory: timeHistoryToday()

    function timeHistoryToday() {
        var timeHistoryArray = [];
        var today = new Date();

        for (var i = 0; i < root.temperatureHistory.length; i++) {
            timeHistoryArray[i] = new Date(today.getFullYear(),
                                           today.getMonth(),
                                           today.getDate(),
                                           i);
        }

        return timeHistoryArray;
    }
}
