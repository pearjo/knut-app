#!/bin/bash

help()
{
   # print the help message
   echo "Usage: build.sh TARGET"
   echo "Builds the Knut app for a specified TARGET."
   echo "targets:"
   echo "  android"
   echo "  desktop"
   echo
   echo "The variables QMAKE_DESKTOP or QMAKE_ANDROID need to be set, pointing"
   echo "to the corresponding qmake verison. When building for the target"
   echo "android, the variables ANDROID_NDK_ROOT, ANDROID_SDK_ROOT and "
   echo "JAVA_HOME need to be set additionaly"
}

while getopts ":h" option; do
  case $option in
    h)
      help
      exit 1
      ;;
    *)
      help
      exit 1
      ;;
  esac
done

case "${1}" in
  android)
    TARGET="android"
    QMAKE=$QMAKE_ANDROID
    ;;
  desktop)
    TARGET="desktop"
    QMAKE=$QMAKE_DESKTOP
    ;;
  *)
    echo "No valid TARGET found."
    help
    exit 1
esac

echo "Build the Knut app for the TARGET $TARGET."

BUILD=build/$TARGET

if [ -z "$QMAKE" ]
then
  echo "Failed: QMAKE is not set for the TARGET $TARGET."
  exit 1
else
  mkdir -p $BUILD
  $QMAKE -o $BUILD
fi

cd build/$TARGET

case $TARGET in
  desktop)
    make
    make install
    ;;
  android)
    make apk
    cp android-build/build/outputs/apk/debug/android-build-debug.apk \
       knut-app.apk
    adb install knut-app.apk
    ;;
esac
