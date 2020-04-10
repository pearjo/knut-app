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
#ifndef TEMPERATURE_CLIENT_HPP
#define TEMPERATURE_CLIENT_HPP

#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QObject>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QStandardItemModel>
#include <QString>
#include <QTcpSocket>
#include <QTime>
#include <QVector>
#include <QtCharts/QSplineSeries>

#include "knutclient.hpp"
#include "temperature.hpp"

#define LOCAL_WEATHER "localWeather"

class TemperatureClient : public QObject
{
    Q_OBJECT

    //! The model of all temperatures with the roles \c location and \c temperature where \c
    //! temperature references to a Temperature service.
    Q_PROPERTY(QStandardItemModel *temperatureModel
               MEMBER temperatureModel
               NOTIFY temperatureModelChanged);
    //! The local weather Temperature object.
    Q_PROPERTY(Temperature *localWeather MEMBER localWeather NOTIFY localWeatherChanged);

public:
    explicit TemperatureClient(QObject *parent = Q_NULLPTR) : QObject(parent) {}
    ~TemperatureClient();

    QHash<QString, QObject *> temperatures() const {return mTemperatures;}
    QStandardItemModel *temperatureModel {nullptr};
    Temperature *localWeather;
    void connectToClient(KnutClient *socket);

    /*! \brief Message ID used to communicate with the Knut server via the
     *         KnutClient::writeRequest().
     *
     *  For more details read the
     *  <a href="https://knut-server.readthedocs.io/en/latest/reference/knutapis.html#knut.apis.Temperature.request_handler">
     *  API documentation</a> of the server.
     */
    enum MessageId {
        //! Requests the temperature status for a single location. The message must have the key \c
        //! uniqueName.
        STATUS_REQUEST  = 0x0001,
        //! The status of a single temperature.
        STATUS_RESPONSE = 0x0101,
        //! Request a list of all temperature locations with their status.
        TEMPERATURE_LIST_REQUEST = 0x0002,
        //! A list of temperature locations with their status.
        TEMPERATURE_LIST_RESPONSE = 0x0102,
        //! Request the temperature history for a single location.
        TEMPERATURE_HISTORY_REQUEST = 0x0003,
        //! The temperature history of a single location with the corresponding time history.
        TEMPERATURE_HISTORY_RESPONSE = 0x0103
    };
    Q_ENUMS(MessageId)

signals:
    void localWeatherChanged();
    void temperatureModelChanged();

public slots:
    void onKnutConnected();
    void onReadyRead(const QJsonObject &payload, const quint8 &serviceId, const quint16 &messageId);

private:
    KnutClient *mKnutClient;
    QHash<QString, QObject *> mTemperatures;
    const quint8 mServiceId = 0x01;
    void requestTemperature();
    void statusResponse(const QJsonObject &payload);
    void temperatureHistoryResponse(const QJsonObject &payload);
    void temperatureListResponse(const QJsonObject &payload);
};

#endif // TEMPERATURE_CLIENT_HPP
