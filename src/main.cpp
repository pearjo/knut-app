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
#include <QApplication>
#include <QAbstractSocket>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QFont>

#include "knutclient.hpp"
#include "services/lightClient.hpp"
#include "services/temperatureClient.hpp"

#ifndef APP_VERSION
#define APP_VERSION "devel"
#endif

int main(int argc, char *argv[])
{
    QCoreApplication::setApplicationName(QStringLiteral("Knut"));
    QCoreApplication::setApplicationVersion(APP_VERSION);
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QCoreApplication::setOrganizationName(QStringLiteral("Knut"));

    QApplication app(argc, argv);
    QQmlApplicationEngine engine;

    KnutClient knutClient;

    // initialize services
    LightClient lightClient;
    lightClient.connectToClient(&knutClient);

    TemperatureClient temperatureClient;
    temperatureClient.connectToClient(&knutClient);

    engine.rootContext()->setContextProperty(QStringLiteral("knutClient"),
                                             &knutClient);
    engine.rootContext()->setContextProperty(QStringLiteral("lightClient"),
                                             &lightClient);
    engine.rootContext()->setContextProperty(QStringLiteral("temperatureClient"),
                                             &temperatureClient);

    engine.addImportPath(QStringLiteral("qrc:/qml/imports"));
    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
