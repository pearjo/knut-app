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
#include "light.hpp"
#include "lightClient.hpp"
#include "lightListModel.hpp"
#include "room.hpp"
#include "roomListModel.hpp"

#include <QJsonArray>

LightClient::~LightClient()
{
    delete lightModel;
    delete roomModel;
    qDeleteAll(mLights);
    qDeleteAll(mRooms);
}

/*! \brief Connects to the KnutClient \a knutClient.
 *
 *  Connects the onKnutConnected() slot to the KnutClient::knutConnected() signal and the
 *  onReadyRead() slot to the signal KnutClient::receivedMessage() signal.
 */
void LightClient::connectToClient(KnutClient *knutClient)
{
    mKnutClient = knutClient;

    connect(mKnutClient, &KnutClient::knutConnected, this, &LightClient::onKnutConnected);
    connect(mKnutClient, &KnutClient::receivedMessage, this, &LightClient::onReadyRead);

    if (mKnutClient->connected)
        onKnutConnected();
}

void LightClient::onKnutConnected()
{
    mKnutClient->writeRequest(mServiceId, LightClient::MessageId::LIGHTS_REQUEST);
    mKnutClient->writeRequest(mServiceId, LightClient::MessageId::ROOMS_LIST_REQUEST);
    mKnutClient->writeRequest(mServiceId, LightClient::MessageId::ALL_LIGHTS_REQUEST);
}

/*! \brief Slot called when a \a message is available.
 *
 *  If a message is received by the KnutClient, this slot is called. If the \a serviceId
 *  is \c 0x02, a corresponding response handle method is called for the \a messageId.
 *
 *  \sa LightClient::MessageId
 */
void LightClient::onReadyRead(const QJsonObject &message, const quint8 &serviceId,
                              const quint16 &messageId)
{
    if (serviceId != mServiceId)
        return;

    switch (messageId) {
        case LightClient::MessageId::LIGHTS_RESPONSE: {
            lightsResponse(message);
            break;
        }
        case LightClient::MessageId::STATUS_RESPONSE: {
            statusResponse(message);
            break;
        }
        case LightClient::MessageId::ALL_LIGHTS_RESPONSE: {
            allLightsResponse(message);
            break;
        }
        case LightClient::MessageId::ROOMS_LIST_RESPONSE: {
            roomsListResponse(message);
            break;
        }
        case LightClient::MessageId::ROOM_RESPONSE: {
            roomResponse(message);
            break;
        }
        default:
            break;
    }
}

//! Handles a LightClient::ALL_LIGHTS_REQUEST.
void LightClient::lightsResponse(const QJsonObject &message)
{
    lightModel = new LightListModel(this);
    lightModel->clear();
    lightModel->setSortRole(RoomRole);

    QJsonArray backends = message["backends"].toArray();

    for (int i = 0; i < backends.size(); ++i) {
        const QJsonObject lightDict = backends[i].toObject();
        Light *newLight = new Light(mKnutClient);

        newLight->location = lightDict["location"].toString();
        newLight->room = lightDict["room"].toString();
        newLight->uniqueName = lightDict["id"].toString();

        newLight->hasColor = lightDict["hasColor"].toBool();
        newLight->hasDimlevel = lightDict["hasDimlevel"].toBool();
        newLight->hasTemperature = lightDict["hasTemperature"].toBool();

        if (newLight->hasTemperature) {
            newLight->colorCold = lightDict["colorCold"].toString();
            newLight->colorWarm = lightDict["colorWarm"].toString();
        }

        newLight->setAll(lightDict["state"].toBool(),
                         lightDict["temperature"].toInt(),
                         lightDict["dimlevel"].toInt(),
                         lightDict["color"].toString());

        mLights.insert(newLight->uniqueName, newLight);

        QStandardItem *lightItem = new QStandardItem;
        lightItem->setData(newLight->location, LocationRole);
        lightItem->setData(newLight->room, RoomRole);
        lightItem->setData(QVariant::fromValue(newLight), LightRole);
        lightModel->appendRow(lightItem);
    }

    lightModel->sort(0);
    emit lightModelChanged();
}

//! Handles a LightClient::ROOMS_LIST_RESPONSE.
void LightClient::roomsListResponse(const QJsonObject &message)
{
    roomModel = new RoomListModel(this);
    roomModel->clear();
    roomModel->setSortRole(RoomListModel::RoomNameRole);

    QJsonArray rooms = message["rooms"].toArray();

    for (int i = 0; i < rooms.size(); ++i) {
        const QJsonObject roomDict = rooms[i].toObject();
        Room *newRoom = new Room(mKnutClient);
        newRoom->room = roomDict["id"].toString();
        newRoom->handleRoomResponse(roomDict["state"].toInt());

        mRooms.insert(newRoom->room, newRoom);

        QStandardItem *roomItem = new QStandardItem;
        roomItem->setData(QVariant::fromValue(newRoom), RoomListModel::RoomRole);
        roomItem->setData(newRoom->room, RoomListModel::RoomNameRole);
        roomModel->appendRow(roomItem);
    }

    roomModel->sort(0);
    emit roomModelChanged();
}

//! Handles a LightClient::ROOM_RESPONSE.
void LightClient::roomResponse(const QJsonObject &message)
{
    QString roomName = message["id"].toString();
    double lightState = message["state"].toInt();
    Room *room = dynamic_cast<Room *>(mRooms[roomName]);
    room->handleRoomResponse(lightState);
}

//! Handles a LightClient::STATUS_RESPONSE
void LightClient::statusResponse(const QJsonObject &message)
{
    const QString uniqueName = message["id"].toString();
    Light *light = static_cast<Light *>(mLights[uniqueName]);
    light->handleStatusResponse(message);
}

//! Sends the \a lightStateAll as LightClient::ALL_LIGHTS_RESPONSE to the Knut server.
void LightClient::setLightStateAll(const float &lightStateAll)
{
    if (lightStateAll == mLightStateAll)
        return;

    QJsonObject message;
    message["state"] = lightStateAll;
    mKnutClient->writeRequest(message, mServiceId, LightClient::ALL_LIGHTS_RESPONSE);
}

//! Handles a LightClient::ALL_LIGHTS_RESPONSE.
void LightClient::allLightsResponse(const QJsonObject &message)
{
    int lightStateAll = message["state"].toInt();

    if (lightStateAll != mLightStateAll) {
        mLightStateAll = lightStateAll;
        emit lightStateAllChanged();
    }
}
