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

    // set default font
    QFont font(QStringLiteral("Roboto"), 12);
    app.setFont(font);

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
