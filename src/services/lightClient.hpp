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
#ifndef LIGHT_CLIENT_HPP
#define LIGHT_CLIENT_HPP

#include <QJsonObject>
#include <QObject>
#include <QStandardItemModel>

#include "knutclient.hpp"

//! Handles all Light services and related Room settings.
class LightClient : public QObject
{
    Q_OBJECT

    //! The model of all lights with the roles \c location, \c room and \c light where \c light
    //! references to a Light service.
    Q_PROPERTY(QStandardItemModel* lightModel MEMBER lightModel NOTIFY lightModelChanged);
    //! The model of all rooms with the roles \c roomName and \c room where \c room
    //! references to a Room.
    Q_PROPERTY(QStandardItemModel* roomModel MEMBER roomModel NOTIFY roomModelChanged);
    //! The state of all lights where \c 0 is all off, \c 1 all on and \c 0.5 neither all on
    //! nor off.
    Q_PROPERTY(float lightStateAll READ lightStateAll WRITE setLightStateAll
               NOTIFY lightStateAllChanged);

public:
    explicit LightClient(QObject *parent = Q_NULLPTR) : QObject(parent) {}
    ~LightClient();

    QHash<QString, QObject *> lights() const {return mLights;}
    QHash<QString, QObject *> rooms() const {return mRooms;}
    QStandardItemModel *lightModel {nullptr};
    QStandardItemModel *roomModel {nullptr};
    float lightStateAll() const {return mLightStateAll;}
    void connectToClient(KnutClient *knutClient);
    void setLightStateAll(const float &lightStateAll);

    //! Message ID used to communicate with the Knut server via the KnutClient::writeRequest().
    enum MessageId {
        //! Requests the status of a Light. The message must have the key \c uniqueName.
        STATUS_REQUEST  = 0x0001,
        //! The status of a Light.
        STATUS_RESPONSE = 0x0101,
        //! Requests the status of all Light.
        LIGHTS_REQUEST  = 0x0002,
        //! A STATUS_RESPONSE for all Light services registered by the Knut server.
        LIGHTS_RESPONSE = 0x0102,
        //! Requests the combined state of all lights.
        ALL_LIGHTS_REQUEST = 0x0003,
        //! The state of all Light services combined. \sa lightStateAll
        ALL_LIGHTS_RESPONSE = 0x0103,
        //! Request a list of all registered Room.
        ROOMS_LIST_REQUEST = 0x0004,
        //! The list of all registered Room.
        ROOMS_LIST_RESPONSE = 0x0104,
        //! Requests the state of a single Room.
        ROOM_REQUEST = 0x0005,
        //! The state of a single Room where the state value is analog to the lightStateAll value.
        ROOM_RESPONSE = 0x0105
    };
    Q_ENUMS(MessageId)

signals:
    void lightStateAllChanged();
    void lightModelChanged();
    void roomModelChanged();

public slots:
    void onKnutConnected();
    void onReadyRead(const QJsonObject &message, const quint8 &serviceId, const quint16 &messageId);

private:
    void allLightsResponse(const QJsonObject &message);
    void lightsResponse(const QJsonObject &message);
    void roomResponse(const QJsonObject &message);
    void roomsListResponse(const QJsonObject &message);
    void statusResponse(const QJsonObject &message);

    KnutClient *mKnutClient;
    QHash<QString, QObject *> mLights;
    QHash<QString, QObject *> mRooms;
    const quint8 mServiceId = 0x02;
    float mLightStateAll = 0;
};

#endif // LIGHT_CLIENT_HPP
