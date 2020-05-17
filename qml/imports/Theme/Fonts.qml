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

Item {
    id: fonts

    property FontLoader noto: FontLoader {
        source: "../../../fonts/noto/NotoSans-Regular.ttf"
    }

    property FontLoader roboto: FontLoader {
        source: "../../../fonts/roboto/RobotoCondensed-Regular.ttf"
    }

    property FontLoader caladea: FontLoader {
        source: "../../../fonts/caladea/Caladea-Regular.ttf"
    }

    property FontLoader weatherIcons: FontLoader {
        source: "../../../fonts/weather-icons/weathericons-regular-webfont.ttf"
    }

    // load all font weights
    FontLoader {
        source: "../../../fonts/noto/NotoSans-Bold.ttf"
    }

    FontLoader {
        source: "../../../fonts/roboto/RobotoCondensed-Bold.ttf"
    }

    FontLoader {
        source: "../../../fonts/roboto/RobotoCondensed-Light.ttf"
    }
}
