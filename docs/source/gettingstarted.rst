.. _gettingstarted:

Getting Started
===============

.. _build:

Build
-----

The Knut app is powered by the Qt framework and requires Qt 5.14.  The app is
build using the ``qmake`` build tool by running from the project root
directory::

   mkdir build
   qmake -o build/
   cd build
   make

To build an Android package (APK), you must use the for android dedicated
``qmake`` command. Furthermore, the environment variables ``JAVA_HOME``,
``ANDROID_SDK_ROOT`` and ``ANDROID_NDK_ROOT`` need to be set. With the correct
build setup, simply repeat the steps above but run make with the argument
``apk`` like::

   make apk

This will generate an ``*.apk`` file located in
`android-build/outputs/apk/debug/android-build-debug.apk` relative to your
``Makefile``.

The generated APK file can be installed directly on your connected phone by
running::

   adb install android-build/outputs/apk/debug/android-build-debug.apk

.. note::

   To get a clean build setup, get Qt from `here <https://www.qt.io/download>`_
   and select also the Android option in the installer. To setup the Android
   environment, you can download the `Android Studio
   <https://developer.android.com/studio>`_ and use its installer to setup the
   Android SDK.
