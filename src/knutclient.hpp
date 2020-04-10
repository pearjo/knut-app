#ifndef KNUTCLIENT_HPP
#define KNUTCLIENT_HPP

#include <QJsonObject>
#include <QObject>
#include <QSettings>
#include <QTcpSocket>

#define HOST_ADDRESS_SETTING "knutClient/hostAddress"
#define PORT_SETTING "knutClient/port"

/*! \brief The client which connects to the <a href="https://github.com/pearjo/knut-server">
 *         Knut server</a>.
 *
 *  The KnutClient can be used by all services to communicate to the Knut server or to get any
 *  messages from the server. Each service can therefore connect to the receivedMessage() signal
 *  to receive any incoming message or send requests using writeRequest().
 *
 *  \sa receivedMessage()
 */
class KnutClient : public QObject
{
    Q_OBJECT

    //! Indicates whether the KnutClient is connected to the Knut server.
    Q_PROPERTY(bool connected MEMBER connected NOTIFY connectedChanged);
    //! The address to which the Knut server is bound.
    Q_PROPERTY(QString hostAddress READ hostAddress WRITE setHostAddress NOTIFY hostAddressChanged)
    //! The port on which the Knut server can be accessed.
    Q_PROPERTY(int port READ port WRITE setPort NOTIFY portChanged)

public:
    explicit KnutClient(QObject *parent = nullptr);
    ~KnutClient();

    QString hostAddress() const {return mHostAddress;}
    bool connected = false;
    int port() const {return mPort;}
    void setHostAddress(const QString &hostAddress);
    void setPort(const int &port);
    void writeRequest(const QJsonObject &message, const quint8 &serviceId,
                      const quint16 &messageId);
    void writeRequest(const quint8 &serviceId, const quint16 &messageId);

signals:
    void connectedChanged();
    void hostAddressChanged();
    void knutConnected();
    void portChanged();
    /*! \brief Emitted when a new \a message is received.
     *
     *  This signal is emitted when a new \a message is received and processed. Any service can
     *  connect to it, check for the \a serviceId and process the \a message of type \a messageId if
     *  needed.
     *
     *  \note
     *  This signal should only be emitted when a valid Knut message is read from the socket by the
     *  onReadyRead() method.
     *
     *  \sa onReadyRead()
     */
    void receivedMessage(const QJsonObject &message, const quint8 &serviceId,
                         const quint16 &messageId);

private slots:
    void mStateChanged(const QAbstractSocket::SocketState &socketState);

public slots:
    void onReadyRead();
    void onReconnect();

private:
    QSettings mSettings;
    QString mHostAddress;
    QTcpSocket mSocket;
    bool mConnectingToKnut = false;
    int mPort;
    int mTimeout = 10000;
    void mConnectSocket();
    void mErrorHandler(const QAbstractSocket::SocketError &socketError);
};

#endif // KNUTCLIENT_HPP
