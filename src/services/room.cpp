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
#include "lightClient.hpp"
#include "room.hpp"

Room::Room(KnutClient *socket,  QObject *parent) : QObject(parent)
{
    mKnutClient = socket;
}

void Room::setRoomState(const int &roomState)
{
    QJsonObject payload;

    if (mRoomState == roomState)
        return;

    mRoomState = roomState;

    payload["id"] = room;
    payload["state"] = mRoomState;
    mKnutClient->writeRequest(payload, mServiceId, LightClient::MessageId::ROOM_REQUEST);
}

/*! \brief Handles a \c ROOM_RESPONSE message.
 *
 *  Handles a \c ROOM_RESPONSE message and updates the \a roomState if it changed.
 *
 *  \sa Room::setRoomState()
 */
void Room::handleRoomResponse(const int &roomState)
{
    if (mRoomState != roomState)
        mRoomState = roomState;

    emit roomStateChanged();
}
