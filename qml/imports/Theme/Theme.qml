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
pragma Singleton

import QtQuick 2.14

QtObject {
    readonly property bool isLight: local.isDaylight

    // animations
    readonly property real animationDuration: 300

    // dimensions
    readonly property real horizontalItemSpace: 8
    readonly property real radius: 6
    readonly property real referenceHeight: 896
    readonly property real referenceWidth: 414
    readonly property real verticalItemSpace: 8

    // fonts
    property font fontH1
    fontH1 {
        capitalization: Font.MixedCase
        family: typefaceHeader.name
        letterSpacing: -1.5
        pixelSize: 96
        weight: Font.Light
    }
    property font fontH2
    fontH2 {
        capitalization: Font.MixedCase
        family: typefaceHeader.name
        letterSpacing: -0.5
        pixelSize: 60
        weight: Font.Light
    }
    property font fontH3
    fontH3 {
        capitalization: Font.MixedCase
        family: typefaceHeader.name
        letterSpacing: 0
        pixelSize: 48
        weight: Font.Normal
    }
    property font fontH4
    fontH4 {
        capitalization: Font.AllUppercase
        family: typefaceSerif.name
        letterSpacing: 0.25
        pixelSize: 26
        weight: Font.Normal
    }
    property font fontH5
    fontH5 {
        capitalization: Font.AllUppercase
        family: typefaceHeader.name
        letterSpacing: 0.15
        pixelSize: 20
        weight: Font.Normal
    }
    property font fontH6
    fontH6 {
        capitalization: Font.MixedCase
        family: typefaceHeader.name
        letterSpacing: 0.15
        pixelSize: 20
        weight: Font.Normal
    }
    property font fontSubtitle1
    fontSubtitle1 {
        capitalization: Font.MixedCase
        family: typefaceBody.name
        letterSpacing: 0.15
        pixelSize: 16
        weight: Font.Normal
    }
    property font fontSubtitle2
    fontSubtitle2 {
        capitalization: Font.MixedCase
        family: typefaceBody.name
        letterSpacing: 0.1
        pixelSize: 14
        weight: Font.Medium
    }
    property font fontBody1
    fontBody1 {
        capitalization: Font.MixedCase
        family: typefaceBody.name
        letterSpacing: 0.5
        pixelSize: 16
        weight: Font.Normal
    }
    property font fontBody2
    fontBody2 {
        capitalization: Font.MixedCase
        family: typefaceBody.name
        letterSpacing: 0.25
        pixelSize: 14
        weight: Font.Normal
    }
    property font fontButton
    fontButton {
        capitalization: Font.AllUppercase
        family: typefaceHeader.name
        letterSpacing: 1.25
        pixelSize: 14
        weight: Font.Light
    }
    property font fontCaption
    fontCaption {
        capitalization: Font.MixedCase
        family: typefaceHeader.name
        letterSpacing: 0.4
        pixelSize: 12
        weight: Font.Normal
    }
    property font fontOverline
    fontOverline {
        capitalization: Font.AllUppercase
        family: typefaceHeader.name
        letterSpacing: 1.5
        pixelSize: 10
        weight: Font.Normal
    }

    readonly property FontLoader typefaceBody: Fonts.noto
    readonly property FontLoader typefaceHeader: Fonts.roboto
    readonly property FontLoader typefaceSerif: Fonts.caladea
    readonly property FontLoader typefaceWeatherIcon: Fonts.weatherIcons

    // colors

    // backdrop and navigation bars
    readonly property color elevated: isLight ? Qt.lighter(background, 2)
                                              : Qt.darker(background, 2)

    // controls
    readonly property color controlActive: isLight ? "#66717E" : accent
    readonly property color controlForeground: controlActive
    readonly property color controlInactive: isLight ? Qt.darker(background, 1.2)
                                                     : Qt.lighter(background, 1.5)

    // general
    readonly property color accent: isLight ? "#000000" : "#FFC68A"
    readonly property color dark: isLight ? "#424242" : "#000000"
    readonly property color light: "#FFFFFF"

    readonly property color background: isLight ? "#FEF9EC" : "#2F2F2F"
    readonly property color backgroundElevated: Qt.darker(background,
                                                          isLight ? 1.1 : 1.5)
    readonly property color brightLayer: Qt.rgba(light.r,
                                                 light.g,
                                                 light.b,
                                                 isLight ? 0.5 : 0.1)
    readonly property color darkLayer: Qt.rgba(dark.r,
                                               dark.g,
                                               dark.b,
                                               isLight ? 0.1 : 0.3)
    readonly property color foreground: isLight ? dark : light
    readonly property color foregroundPressed: "#FAFAFA"
    readonly property real opacity: 0.5
    readonly property real popupOpacity: 0.8

    // margins
    readonly property real horizontalMargin: 16
    readonly property real verticalMargin: 8

    // shadows
    readonly property color shadowColor: darkLayer
    readonly property real shadowHorizontalOffset: 0
    readonly property real shadowRadius: 10
    readonly property real shadowSamples: 17
    readonly property real shadowVerticalOffset: 0

    // text
    readonly property color textAccent: isLight ? "#000000" : accent
    readonly property color textBackground: background
    readonly property color textForeground: isLight ? "#616161" : "#E5E5E5"
    readonly property color textDisabled: isLight ? Qt.lighter(textForeground, 1.5)
                                                  : Qt.darker(textForeground, 1.5)
}
