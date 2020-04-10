pragma Singleton

import QtQuick 2.14

QtObject {
    // animations
    readonly property real animationDuration: 300

    // controls
    readonly property color controlActive: accent
    readonly property color controlBackground: "#121212"
    readonly property color controlForeground: accent
    readonly property color controlInactive: "#424242"

    // dimensions
    readonly property real horizontalItemSpace: 8
    readonly property real radius: 8
    readonly property real referenceHeight: 812
    readonly property real referenceWidth: 375
    readonly property real verticalItemSpace: 8

    // fonts
    property font fontH1
    fontH1 {
        capitalization: Font.MixedCase
        family: typeface
        letterSpacing: -1.5
        pixelSize: 96
        weight: Font.Light
    }
    property font fontH2
    fontH2 {
        capitalization: Font.MixedCase
        family: typeface
        letterSpacing: -0.5
        pixelSize: 60
        weight: Font.Light
    }
    property font fontH3
    fontH3 {
        capitalization: Font.MixedCase
        family: typeface
        letterSpacing: 0
        pixelSize: 48
        weight: Font.Normal
    }
    property font fontH4
    fontH4 {
        capitalization: Font.MixedCase
        family: typeface
        letterSpacing: 0.25
        pixelSize: 34
        weight: Font.Normal
    }
    property font fontH5
    fontH5 {
        capitalization: Font.AllUppercase
        family: typeface
        letterSpacing: 0.15
        pixelSize: 20
        weight: Font.Normal
    }
    property font fontH6
    fontH6 {
        capitalization: Font.MixedCase
        family: typeface
        letterSpacing: 0.15
        pixelSize: 20
        weight: Font.Medium
    }
    property font fontSubtitle1
    fontSubtitle1 {
        capitalization: Font.MixedCase
        family: typeface
        letterSpacing: 0.15
        pixelSize: 16
        weight: Font.Normal
    }
    property font fontSubtitle2
    fontSubtitle2 {
        capitalization: Font.MixedCase
        family: typeface
        letterSpacing: 0.1
        pixelSize: 14
        weight: Font.Medium
    }
    property font fontBody1
    fontBody1 {
        capitalization: Font.MixedCase
        family: typeface
        letterSpacing: 0.5
        pixelSize: 16
        weight: Font.Normal
    }
    property font fontBody2
    fontBody2 {
        capitalization: Font.MixedCase
        family: typeface
        letterSpacing: 0.25
        pixelSize: 14
        weight: Font.Normal
    }
    property font fontButton
    fontButton {
        capitalization: Font.AllUppercase
        family: typeface
        letterSpacing: 1.25
        pixelSize: 14
        weight: Font.Light
    }
    property font fontCaption
    fontCaption {
        capitalization: Font.MixedCase
        family: typeface
        letterSpacing: 0.4
        pixelSize: 12
        weight: Font.Normal
    }
    property font fontOverline
    fontOverline {
        capitalization: Font.AllUppercase
        family: typeface
        letterSpacing: 1.5
        pixelSize: 10
        weight: Font.Normal
    }
    property string typeface: "Roboto Condensed"

    // general
    readonly property color accent: "#D5A56B"
    /* readonly property color accent: "#FFAF5F" */
    readonly property color background: "#2F2F2F"
    readonly property color backgroundElevated: "#212121"
    readonly property color darkLayer: "#80000000"
    readonly property color foreground: "#FAFAFA"
    readonly property color foregroundPressed: "#FAFAFA"
    readonly property real opacity: 0.5

    // margins
    readonly property real horizontalMargin: 16
    readonly property real verticalMargin: 8

    // shadows
    readonly property color shadowColor: "#80000000"
    readonly property real shadowHorizontalOffset: 0
    readonly property real shadowRadius: 10.0
    readonly property real shadowSamples: 17
    readonly property real shadowVerticalOffset: 0

    // text
    readonly property color textAccent: accent
    readonly property color textBackground: background
    readonly property color textForeground: foreground
}
