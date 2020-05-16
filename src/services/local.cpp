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
#include "local.hpp"

Local::Local(KnutClient *client,  QObject *parent) : QObject(parent)
{
    connectToClient(client);
}

/*! \brief Connects to the KnutClient \a knutClient.
 *
 *  Connects the onKnutConnected() slot to the KnutClient::knutConnected() signal and the
 *  onReadyRead() slot to the signal KnutClient::receivedMessage() signal.
 */
void Local::connectToClient(KnutClient *knutClient)
{
    mKnutClient = knutClient;

    connect(mKnutClient, &KnutClient::knutConnected, this, &Local::onKnutConnected);
    connect(mKnutClient, &KnutClient::receivedMessage, this, &Local::onReadyRead);

    if (mKnutClient->connected)
        onKnutConnected();
}

void Local::onKnutConnected()
{
    mKnutClient->writeRequest(mServiceId, Local::MessageType::LOCAL_REQUEST);
}

/*! \brief Slot called when a \a message is available.
 *
 *  If a message is received by the KnutClient, this slot is called. If the \a serviceId
 *  is \c 0x04, the message will be handled.
 *
 *  \sa Local::MessageType
 */
void Local::onReadyRead(const QJsonObject &message, const quint8 &serviceId,
                        const quint16 &messageType)
{
    if (serviceId != mServiceId)
        return;

    switch (messageType) {
        case Local::MessageType::LOCAL_RESPONSE: {
            mIsDaylight = message["isDaylight"].toBool();
            mLocation = message["location"].toString();
            mNextSunRise = QDateTime::fromSecsSinceEpoch(message["sunrise"].toInt());
            mNextSunSet = QDateTime::fromSecsSinceEpoch(message["sunset"].toInt());

            emit isDaylightChanged();
            emit locationChanged();
            emit nextSunRiseChanged();
            emit nextSunSetChanged();

            break;
        }
        default:
            qWarning("Received an invalid message type for the local service...");
            break;
    }
}
