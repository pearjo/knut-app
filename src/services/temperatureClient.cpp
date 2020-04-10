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
#include "temperatureClient.hpp"
#include "temperatureListModel.hpp"

TemperatureClient::~TemperatureClient()
{
    qDeleteAll(mTemperatures);
}

/*! \brief Connects to the KnutClient \a knutClient.
 *
 *  Connects the onKnutConnected() slot to the KnutClient::knutConnected() signal and the
 *  onReadyRead() slot to the signal KnutClient::receivedMessage() signal.
 */
void TemperatureClient::connectToClient(KnutClient *knutClient)
{
    mKnutClient = knutClient;

    connect(mKnutClient, &KnutClient::knutConnected, this, &TemperatureClient::onKnutConnected);
    connect(mKnutClient, &KnutClient::receivedMessage, this, &TemperatureClient::onReadyRead);

    localWeather = new Temperature(mKnutClient);
    localWeather->uniqueName = LOCAL_WEATHER;
    mTemperatures.insert(localWeather->uniqueName, localWeather);

    if (mKnutClient->connected)
        onKnutConnected();
}

//! Slot is called when the connection state of the KnutClient to the Knut server changed.
void TemperatureClient::onKnutConnected()
{
    // request temperature list
    mKnutClient->writeRequest(mServiceId, TemperatureClient::MessageId::TEMPERATURE_LIST_REQUEST);
}

/*! \brief Slot called when a \a message is available.
 *
 *  If a message is received by the KnutClient, this slot is called. If the \a serviceId
 *  is \c 0x01, a corresponding response handle method is called for the \a messageId.
 *
 *  \sa TemperatureClient::MessageId
 */
void TemperatureClient::onReadyRead(const QJsonObject &payload, const quint8 &serviceId,
                                    const quint16 &messageId)
{
    if (serviceId != mServiceId)
        return;

    switch (messageId) {
        case TemperatureClient::MessageId::STATUS_RESPONSE: {
            statusResponse(payload);
            break;
        }
        case TemperatureClient::MessageId::TEMPERATURE_LIST_RESPONSE: {
            temperatureListResponse(payload);
            break;
        }
        case TemperatureClient::MessageId::TEMPERATURE_HISTORY_RESPONSE: {
            temperatureHistoryResponse(payload);
            break;
        }
        default:
            break;
    }
}

//! Handles a TemperatureClient::STATUS_RESPONSE.
void TemperatureClient::statusResponse(const QJsonObject &payload)
{
    for (QString uniqueName : payload.keys()) {
        const QJsonObject statusDict = payload[uniqueName].toObject();
        Temperature *temperature = dynamic_cast<Temperature *>(mTemperatures[uniqueName]);

        if (temperature == Q_NULLPTR) {
            qWarning() << "Received invalid STATUS_RESPONSE response for"
                       << uniqueName << ".";
            return;
        }

        temperature->location = statusDict["location"].toString();
        emit temperature->locationChanged();
        temperature->unit = statusDict["unit"].toString();
        emit temperature->unitChanged();
        temperature->condition = statusDict["condition"].toString();
        emit temperature->conditionChanged();
        temperature->temperature = statusDict["temperature"].toDouble();
        emit temperature->temperatureChanged();
        temperature->timeHistory.append(QDateTime::currentMSecsSinceEpoch());
        emit temperature->timeHistoryChanged();
        temperature->temperatureHistory.append(temperature->temperature);
        emit temperature->temperatureHistoryChanged();
    }
}

/*! \brief Handles a TemperatureClient::TEMPERATURE_LIST_RESPONSE.
 *
 *  If a temperature with the \c uniqueName \c localWeather is in the list of temperatures,
 *  it is set as the \a localWeather temperature.
 */
void TemperatureClient::temperatureListResponse(const QJsonObject &payload)
{
    temperatureModel = new TemperatureListModel(this);
    temperatureModel->clear();
    temperatureModel->setSortRole(TemperatureListModel::LocationRole);

    for (QString temperature : payload.keys()) {
        const QJsonObject temperatureDict = payload[temperature].toObject();
        Temperature *newTemperature = new Temperature(mKnutClient);

        newTemperature->uniqueName = temperature;
        newTemperature->location = temperatureDict["location"].toString();
        emit newTemperature->locationChanged();
        newTemperature->unit = temperatureDict["unit"].toString();
        emit newTemperature->unitChanged();
        newTemperature->temperature = temperatureDict["temperature"].toDouble();
        emit newTemperature->temperatureChanged();
        newTemperature->condition = temperatureDict["condition"].toString();
        emit newTemperature->conditionChanged();

        // update the local weather
        if (temperature == LOCAL_WEATHER) {
            localWeather = newTemperature;
            emit localWeatherChanged();
        }

        mTemperatures.insert(newTemperature->uniqueName, newTemperature);

        // request the temperature history
        QJsonObject request;
        request["uniqueName"] = newTemperature->uniqueName;
        mKnutClient->writeRequest(request,
                                  mServiceId,
                                  TemperatureClient::MessageId::TEMPERATURE_HISTORY_REQUEST);

        QStandardItem *temperatureItem = new QStandardItem;
        temperatureItem->setData(QVariant::fromValue(newTemperature),
                                 TemperatureListModel::TemperatureRole);
        temperatureItem->setData(newTemperature->location,
                                 TemperatureListModel::LocationRole);
        temperatureModel->appendRow(temperatureItem);
    }

    temperatureModel->sort(0);
    emit temperatureModelChanged();
}

//! Handles a TemperatureClient::TEMPERATURE_HISTORY_RESPONSE.
void TemperatureClient::temperatureHistoryResponse(const QJsonObject &payload)
{
    QString uniqueName = payload["uniqueName"].toString();
    QJsonArray time = payload["time"].toArray();
    QJsonArray history = payload["temperature"].toArray();
    Temperature *temperature = dynamic_cast<Temperature *>(mTemperatures[uniqueName]);
    QDateTime dateTime;

    if (temperature == Q_NULLPTR) {
        qWarning() << "Received invalid TEMPERATURE_HISTORY_RESPONSE for"
                   << uniqueName << ".";
        return;
    }

    for (int i = 0; i < time.size(); ++i) {
        temperature->temperatureHistory.append(history[i].toDouble());
        temperature->timeHistory.append(static_cast<qint64>(time[i].toDouble()*1000));
    }

    temperature->temperatureHistory.append(temperature->temperature);
    temperature->timeHistory.append(QDateTime::currentMSecsSinceEpoch());

    emit temperature->timeHistoryChanged();
    emit temperature->temperatureHistoryChanged();
}
