[![CodeFactor](https://www.codefactor.io/repository/github/pearjo/knut-app/badge)](https://www.codefactor.io/repository/github/pearjo/knut-app)
[![Documentation Status](https://readthedocs.org/projects/knut-app/badge/?version=latest)](https://knut-app.readthedocs.io/en/latest/?badge=latest)
[![License](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://github.com/pearjo/knut-server/blob/master/LICENSE)

# Knut App

*Knut* is a friendly penguin to help organize your home.

The Knut app is a client for the [Knut Server](https://github.com/pearjo/knut-server).

![Image of the Knut app](https://github.com/pearjo/knut-app/blob/master/images/showcase.png)

## Install

The Knut app requires Qt 5.14. To build and install the app for your
desktop, simply run

```bash
QMAKE_DESKTOP=/path/to/your/qmake ./build.sh desktop
```

### Build and install the Android app

To build Knut for Android, make sure to set `QMAKE_ANDROID` to the
correct `qmake` version and set the `ANDROID_NDK_ROOT`,
`ANDROID_SDK_ROOT` and `JAVA_HOME` variables. All left is to simply
plug an Android device onto you PC and run

```bash
./build.sh android
```

### Build it the (not really) hard way

If you wanna build the app manually, check out the *Build* section in
the *Getting Started* chapter of the documentation.

## Build the documentation

The App code documentation is build using Doxygen and Sphinx combined.
Make sure to have Doxygen and Sphinx installed. Furthermore, the
Sphinx part requires some additional Python packages. Install them by
running ``pip install -r requirements.txt`` from within the *docs*
directory. After that you can run

```bash
make html
```

from within the *docs* directory. This builds the documentation with
the index file *build/html/index.html*.
