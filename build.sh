#!/bin/bash
# Copyright (C) 2020  Joe Pearson
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

help()
{
   # print the help message
   echo "Usage: build.sh [OPTION] TARGET"
   echo "Builds the Knut app for a specified TARGET."
   echo "options:"
   echo "  -h  Print this help message"
   echo
   echo "targets:"
   echo "  android"
   echo "  desktop"
   echo
   echo "The variables QMAKE_DESKTOP or QMAKE_ANDROID need to be set, pointing"
   echo "to the corresponding qmake verison. When building for the target"
   echo "android, the variables ANDROID_NDK_ROOT, ANDROID_SDK_ROOT and "
   echo "JAVA_HOME need to be set additionaly"
}

# options
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

# get build target
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

# run qmake for the specified target
BUILD=build/$TARGET

if [ -z "$QMAKE" ]
then
  echo "Failed: QMAKE is not set for the TARGET $TARGET."
  exit 1
else
  mkdir -p $BUILD
  $QMAKE -o $BUILD
fi

# build the knut app for the target
echo "Build the Knut app for the TARGET $TARGET."

pushd build/$TARGET

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

popd
