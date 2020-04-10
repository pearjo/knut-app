#include "lightClient.hpp"
#include "room.hpp"

Room::Room(KnutClient *socket,  QObject *parent) : QObject(parent)
{
    mKnutClient = socket;
}

void Room::setRoomState(const float &roomState)
{
    QJsonObject payload;

    if (mRoomState == roomState)
        return;

    mRoomState = roomState;

    payload["room"] = room;
    payload["state"] = mRoomState;
    mKnutClient->writeRequest(payload, mServiceId, LightClient::MessageId::ROOM_REQUEST);
}

/*! \brief Handles a \c ROOM_RESPONSE message.
 *
 *  Handles a \c ROOM_RESPONSE message and updates the \a roomState if it changed.
 *
 *  \sa Room::setRoomState()
 */
void Room::handleRoomResponse(const float &roomState)
{
    if (mRoomState != roomState)
        mRoomState = roomState;

    emit roomStateChanged();
}
