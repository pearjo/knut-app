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
