import QtGraphicalEffects 1.14
import QtQuick 2.14

//! \brief Overlays a \a source icon with a custom \a color overlay.
Item {
    id: root

    //! The icon color.
    property alias color: colorOverlay.color
    //! The URL of the icon.
    property alias source: svgIcon.source

    implicitHeight: 40
    implicitWidth: 40

    Image {
        id: svgIcon

        anchors.fill: parent

        antialiasing: true
        sourceSize.height: height
        sourceSize.width: width
        visible: false
    }

    ColorOverlay{
        id: colorOverlay

        anchors.fill: svgIcon

        antialiasing: true
        source: svgIcon
    }
}
