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

const QString KnutClient::HOST_ADDRESS_SETTING = QStringLiteral("knutClient/hostAddress");
const QString KnutClient::PORT_SETTING = QStringLiteral("knutClient/port");
const int KnutClient::RECONNECT_TIMEOUT = 1000;

KnutClient::KnutClient(QObject *parent) :
    QObject(parent),
    mSocket(this)
{
    // load settings
    mHostAddress = mSettings.value(HOST_ADDRESS_SETTING, "").toString();
    mPort = mSettings.value(PORT_SETTING, 8080).toInt();

    // set reconnect timer
    mReconnectTimer = new QTimer(this);
    mReconnectTimer->setInterval(RECONNECT_TIMEOUT);
    connect(mReconnectTimer, SIGNAL(timeout()), this, SLOT(mConnectSocket()));

    mSocket.setSocketOption(QAbstractSocket::KeepAliveOption, 1);

    connect(&mSocket, SIGNAL(error(QAbstractSocket::SocketError)),
            this, SLOT(mErrorHandler(QAbstractSocket::SocketError)));
    connect(&mSocket, SIGNAL(disconnected()), this, SLOT(onDisconnected()));
    connect(&mSocket, SIGNAL(readyRead()), this, SLOT(onReadyRead()));

    mConnectSocket();
}

KnutClient::~KnutClient()
{
    delete mReconnectTimer;
}

//! Connects the KnutClient to the socket.
void KnutClient::mConnectSocket()
{
    if (mSocket.state() != QAbstractSocket::SocketState::UnconnectedState
        || mHostAddress.length() == 0)
        return;

    qDebug("Socket is not connected: Connecting socket...");

    mSocket.abort();
    mSocket.connectToHost(QHostAddress(mHostAddress), mPort);

    if (mSocket.waitForConnected(RECONNECT_TIMEOUT)) {
        qDebug() << "Connected to host:" << mSocket.peerAddress();

        if (!connected) {
            connected = true;
            emit connectedChanged();
        }

        emit knutConnected();
    } else {
        mReconnectTimer->start();
    }
}

/*! \brief Executed when the socket is disconnected.
 *
 *  Sets the \a connected property to false and starts a reconnection timer
 */
void KnutClient::onDisconnected()
{
    if (connected) {
        connected = false;
        emit connectedChanged();

        mReconnectTimer->start();
    }
}

/*! \brief Reads a message from the socket.
 *
 *  Reads a null terminated Knut message from the socket as specified <a
 *  href="https://knut-server.readthedocs.io/en/latest/reference/knutserver.html"> here</a>. The
 *  JSON message must have the keys \c "serviceid", \c "msgid" and \c "msg". Those are read from the
 *  message and the signal receivedMessage() is emitted with the \a messsage, \a serviceId and \a
 *  messageId.
 *
 *  As long as the socket has data available, data are read from the socket and for each message,
 *  the signal receivedMessage() is emitted.
 *
 *  \sa receivedMessage()
 */
void KnutClient::onReadyRead()
{
    QByteArray buffer;
    QJsonObject message;
    quint16 messageId = 0;
    quint8 serviceId = 0;

    while (mSocket.bytesAvailable() && !mSocket.atEnd()) {
        buffer += mSocket.read(1);

        if (buffer.endsWith('\0') && buffer.length() > 1) {
            // remove null bytes and trim for conversion to JSON
            buffer = buffer.replace('\0', ' ');
            buffer = buffer.trimmed();

            QJsonDocument dataDoc = QJsonDocument::fromJson(buffer);
            QJsonObject data = dataDoc.object();
            QJsonObject message = data["msg"].toObject();
            serviceId = data["serviceid"].toInt();
            messageId = data["msgid"].toInt();

            buffer.clear();

            qDebug().noquote() << QString("Received message %1 for service %2:").arg(messageId).arg(serviceId)
                               << message;

            emit receivedMessage(message, serviceId, messageId);
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

    qDebug() << "Set host address:" << mHostAddress;
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

/*! \brief Writes a request to the socket with a \a message.
 *
 *  Write a request for the service \a serviceId and the JSON formatted \a message with it's
 *  \a messageId identifier to the socket.
 */
void KnutClient::writeRequest(const QJsonObject &message, const quint8 &serviceId,
                              const quint16 &messageId)
{
    QJsonDocument dataDoc;
    QJsonObject data;

    data["serviceid"] = serviceId;
    data["msgid"] = messageId;
    data["msg"] = message;
    dataDoc.setObject(data);

    if (mSocket.isWritable()) {
        mSocket.write(dataDoc.toJson(QJsonDocument::Compact).append('\0'));

        if (mSocket.waitForBytesWritten()) {
            qDebug().noquote() << QString("Send message %1 for service %2:").arg(messageId).arg(serviceId)
                               << message;
        }
    }
}

/*! \brief Writes a request to the socket without message.
 *
 *  Write a request to the socket for the service \a serviceId and the \a messageId where the
 *  message is not required to have a JSON formatted message.
 */
void KnutClient::writeRequest(const quint8 &serviceId, const quint16 &messageId)
{
    QJsonObject data;
    writeRequest(data, serviceId, messageId);
}

void KnutClient::mErrorHandler(const QAbstractSocket::SocketError &socketError)
{
    qDebug() << "Socket error:" << socketError;
    onDisconnected();
}
