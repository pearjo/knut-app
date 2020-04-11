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
#include <QAbstractSocket>
#include <QDataStream>
#include <QHostAddress>
#include <QJsonDocument>
#include <QTimer>
#include <QtGlobal>

#include "knutclient.hpp"

KnutClient::KnutClient(QObject *parent) :
    QObject(parent),
    mSocket(this)
{
    // load settings
    mHostAddress = mSettings.value(HOST_ADDRESS_SETTING, "").toString();
    mPort = mSettings.value(PORT_SETTING, 8080).toInt();

    // set heartbeat timer
    mHeartbeatTimer = new QTimer(this);
    // wait by a factor of 1.1 longer for the heartbeat
    mHeartbeatTimer->setInterval(1 / HEARTBEAT_FREQUENCY * 1100);
    connect(mHeartbeatTimer, SIGNAL(timeout()), this, SLOT(mHeartbeatMissed()));

    mSocket.setSocketOption(QAbstractSocket::KeepAliveOption, 1);

    connect(&mSocket, SIGNAL(error(QAbstractSocket::SocketError)),
            this, SLOT(mErrorHandler(QAbstractSocket::SocketError)));
    connect(&mSocket, SIGNAL(readyRead()), this, SLOT(onReadyRead()));

    mConnectSocket();
}

KnutClient::~KnutClient()
{
}

//! Connects the KnutClient to the socket.
void KnutClient::mConnectSocket()
{
    if (mSocket.state() != QAbstractSocket::SocketState::UnconnectedState
        || mHostAddress.length() == 0)
        return;

    qDebug() << "Socket is not connected. Connecting socket...";
    mConnectingToKnut = true;

    mSocket.abort();
    mSocket.connectToHost(QHostAddress(mHostAddress), mPort);

    if (mSocket.waitForConnected(CONNECT_TIMEOUT)) {
        qDebug() << "Connected to host" << mHostAddress << "on port" << mPort;

        if (!connected) {
            connected = true;
            emit connectedChanged();
        }

        emit knutConnected();
    } else {
        mHeartbeatTimer->start();
    }

    mConnectingToKnut = false;
}

/*! \brief Read a message from the socket.
 *
 *  Read a Knut message from the socket as specified <a
 *  href="https://knut-server.readthedocs.io/en/latest/reference/knutserver.html"> here</a>. The
 *  first four bytes are the \c messageSize as a unsigned integer, and the following \c messageSize
 *  bytes is the message as a UTF-8 encoded JSON string. The JSON message must have the keys \c
 *  serviceId, \c msgId and \c msg. Those are read from the message and the signal receivedMessage()
 *  is emitted with \c msg as \a messsage, \c serviceId as \a serviceId and \c msgId as \a
 *  messageId.
 *
 *  As long as the socket has data available, data are read from the socket and for each message,
 *  the signal \a receivedMessage() is emitted.
 *
 *  \sa receivedMessage()
 */
void KnutClient::onReadyRead()
{
    QByteArray buffer;
    QDataStream in(&mSocket);
    quint16 messageId = 0;
    quint32 messageSize = 0;
    quint8 serviceId = 0;
    QJsonObject message;

    while (mSocket.bytesAvailable() && !mSocket.atEnd()) {
        // read message header
        in >> messageSize;

        if (messageSize > 0) {
            qDebug() << "Read" << messageSize << "bytes from socket...";

            buffer = mSocket.read(messageSize);

            // read rest of the message if it's split in multiple packets
            while (buffer.size() < int(messageSize)) {
                mSocket.waitForReadyRead();
                buffer.append(mSocket.read(messageSize - buffer.size()));
            }

            QJsonDocument dataDoc = QJsonDocument::fromJson(buffer);
            QJsonObject data = dataDoc.object();
            QJsonObject message = data["msg"].toObject();
            serviceId = data["serviceId"].toInt();
            messageId = data["msgId"].toInt();

            // don't log the server's heartbeat
            if (serviceId > 0 && messageId > 0) {
                qDebug() << "Received for service"
                         << serviceId
                         << "the message"
                         << messageId
                         << message;
                emit receivedMessage(message, serviceId, messageId);
            }
        } else if (messageSize == 0) {
            // received a heartbeat
            mHeartbeatTimer->start();
        }
    }
}

//! Changes the \a hostAddress to which the KnutClient is bound and reconnects to it.
void KnutClient::setHostAddress(const QString &hostAddress)
{
    if (mHostAddress == hostAddress)
        return;

    mHostAddress = hostAddress;
    mConnectSocket();

    qDebug() << "Set host address to " << mHostAddress;
    mSettings.setValue(HOST_ADDRESS_SETTING, mHostAddress);

    emit hostAddressChanged();
}

//! Changes the \a port of the socket connection and reconnects to the server.
void KnutClient::setPort(const int &port)
{
    if (mPort == port)
        return;

    mPort = port;
    mConnectSocket();

    mSettings.setValue(PORT_SETTING, mPort);

    emit portChanged();
}

/*! \brief Write a request on the socket with a \a message.
 *
 *  Write a request on the socket with a JSON formatted \a message, the \a serviceId and \a
 *  messageId.
 */
void KnutClient::writeRequest(const QJsonObject &message, const quint8 &serviceId,
                              const quint16 &messageId)
{
    QJsonDocument dataDoc;
    QJsonObject data;
    quint32 messageSize;

    data["serviceId"] = serviceId;
    data["msgId"] = messageId;
    data["msg"] = message;

    dataDoc.setObject(data);
    messageSize = dataDoc.toJson().size();

    QDataStream out(&mSocket);
    out << messageSize;

    if (mSocket.isWritable()) {
        mSocket.write(dataDoc.toJson());

        if (mSocket.waitForBytesWritten()) {
            qDebug() << "Message"
                     << message
                     << "for service"
                     << serviceId
                     << "with the message ID"
                     << QString("0x%1").arg(messageId, 4, 16, QLatin1Char('0'));
        }
    }
}

/*! \brief Write a request on the socket without message.
 *
 *  Write a request on the socket with the \a serviceId and \a messageId for which the Knut server
 *  doesn't require any message.
 */
void KnutClient::writeRequest(const quint8 &serviceId, const quint16 &messageId)
{
    QJsonDocument dataDoc;
    QJsonObject data;
    quint32 messageSize;

    data["serviceId"] = serviceId;
    data["msgId"] = messageId;
    data["msg"] = "";

    dataDoc.setObject(data);
    messageSize = dataDoc.toJson().size();

    QDataStream out(&mSocket);
    out << messageSize;

    if (mSocket.isWritable()) {
        mSocket.write(dataDoc.toJson());

        qDebug() << "Send request for service"
                 << serviceId
                 << "with the message ID"
                 << QString("0x%1").arg(messageId, 4, 16, QLatin1Char('0'));
    }
}

void KnutClient::mErrorHandler(const QAbstractSocket::SocketError &socketError)
{
    qDebug() << "Socket error: " << socketError;
}

/*! \brief This slot is called if no heartbeat is received.
 *
 *  If no heartbeat is received from the Knut server, this slot is called. The connection state is
 *  set to \c false, the socket is disconnected and a reconnect to the server is attempted.
 *
 *  \sa mConnectSocket()
 */
void KnutClient::mHeartbeatMissed()
{
    qWarning("Heartbeat missed");

    if (connected) {
        connected = false;
        emit connectedChanged();
    }

    if (mSocket.state() != QAbstractSocket::SocketState::UnconnectedState)
        mSocket.disconnectFromHost();

    mConnectSocket();

    mHeartbeatTimer->start();
}
