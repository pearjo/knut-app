# The version number of the Knut app following the semver scheme.
VERSION = 0.0.1

QT += quick qml network gui widgets charts svg
CONFIG += c++11 console
TARGET = knut

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += \
    QT_DEPRECATED_WARNINGS \
    APP_VERSION=\\\"$$VERSION\\\"

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

RESOURCES += \
    $$files($$PWD/fonts/roboto/src/hinted/*.ttf) \
    $$files($$PWD/fonts/weather-icons/font/*.ttf) \
    $$files($$PWD/images/*.svg) \
    $$files($$PWD/images/icons/*.svg) \
    $$files($$PWD/qml/*.qml) \
    $$files($$PWD/qml/imports/*) \
    $$files($$PWD/qml/knut/*.qml) \
    $$files($$PWD/qml/lights/*.qml) \
    $$files($$PWD/qml/screens/*.qml) \
    $$files($$PWD/qml/temperature/*.qml)

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH += \
    $$PWD/qml \
    $$PWD/qml/imports

# Additional import path used to resolve QML modules just for Qt Quick Designer
# QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

# Path to android manifest
DISTFILES += \
    $$PWD/android-sources/AndroidManifest.xml \
    $$PWD/android-sources/build.gradle \
    $$PWD/android-sources/gradle/wrapper/gradle-wrapper.jar \
    $$PWD/android-sources/gradle/wrapper/gradle-wrapper.properties \
    $$PWD/android-sources/gradlew \
    $$PWD/android-sources/gradlew.bat \
    $$PWD/android-sources/res/values/libs.xml

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android-sources

android {
    ANDROID_VERSION_NAME = $$VERSION
}

INCLUDEPATH += \
    $$PWD/src \
    $$PWD/src/services

HEADERS += \
    $$PWD/src/*.hpp \
    $$PWD/src/services/*.hpp

SOURCES += \
    $$PWD/src/*.cpp \
    $$PWD/src/services/*.cpp

desktop.files += knut-app.desktop
desktop.path = ~/.local/share/applications
icon.files += images/knut-app.svg
icon.path = ~/.local/share/icons
target.path = ~/.local/bin

INSTALLS += desktop icon target
