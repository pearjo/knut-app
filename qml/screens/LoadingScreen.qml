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
import Knut.Theme 1.0
import QtGraphicalEffects 1.14
import QtQuick 2.14

Rectangle {
    id: root

    implicitHeight: Theme.referenceHeight
    implicitWidth: Theme.referenceWidth

    color: Theme.background
    opacity: knutClient.connected ? 0 : 1

    Image {
        id: loadingImage

        width: 140

        anchors.centerIn: parent

        antialiasing: true
        fillMode: Image.PreserveAspectFit
        source: "../../images/icons/knut.svg"
        sourceSize.height: height
        sourceSize.width: width
        visible: false
    }

    ColorOverlay {
        id: colorOverlay

        anchors.fill: loadingImage

        antialiasing: true
        color: Theme.foreground
        source: loadingImage
    }

    Behavior on opacity {
        NumberAnimation {
            duration: Theme.animationDuration
            easing.type: Easing.OutQuad;
        }
    }
}
