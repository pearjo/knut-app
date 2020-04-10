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

    mSocket.setSocketOption(QAbstractSocket::KeepAliveOption, 1);

    connect(&mSocket, SIGNAL(error(QAbstractSocket::SocketError)),
            this, SLOT(mErrorHandler(QAbstractSocket::SocketError)));
    connect(&mSocket, SIGNAL(readyRead()), this, SLOT(onReadyRead()));
    connect(&mSocket, SIGNAL(stateChanged(QAbstractSocket::SocketState)),
            this, SLOT(mStateChanged(QAbstractSocket::SocketState)));

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

    if (mSocket.waitForConnected(mTimeout)) {
        qDebug() << "Connected to host" << mHostAddress << "on port" << mPort;
        emit knutConnected();
    } else {
        QTimer *timer = new QTimer(this);
        connect(timer, SIGNAL(timeout()), this, SLOT(onReconnect()));
        timer->start(mTimeout);
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

        qDebug() << "Received for service" << serviceId << "the message" << messageId << message;

        emit receivedMessage(message, serviceId, messageId);
    }
}

void KnutClient::onReconnect()
{
    if (!mConnectingToKnut)
        mConnectSocket();
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

//! Handles a state change of the socket and reconnects if needed.
void KnutClient::mStateChanged(const QAbstractSocket::SocketState &socketState)
{
    switch (socketState) {
        case QAbstractSocket::SocketState::ConnectedState:
            connected = true;
            connectedChanged();
            break;
        case QAbstractSocket::SocketState::UnconnectedState:
            connected = false;
            connectedChanged();
            if (!mConnectingToKnut)
                mConnectSocket();
            break;
        default:
            break;
    }
}
