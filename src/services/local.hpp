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
#ifndef LOCAL_HPP
#define LOCAL_HPP

#include <QDateTime>
#include <QObject>

#include "../knutclient.hpp"

//! A implementation of the Knut local service.
class Local : public QObject
{
    Q_OBJECT

    //! This property describes whether it is currently day or night.
    Q_PROPERTY(bool isDaylight READ isDaylight NOTIFY isDaylightChanged)

    //! This property holds the date and time of the next sun rise.
    Q_PROPERTY(QDateTime nextSunRise READ nextSunRise NOTIFY nextSunRiseChanged)

    //! This property holds the date and time of the next sun set.
    Q_PROPERTY(QDateTime nextSunSet READ nextSunSet NOTIFY nextSunSetChanged)

    //! This property holds the location name.
    Q_PROPERTY(QString location READ location CONSTANT);

public:
    explicit Local(KnutClient *socket, QObject *parent = Q_NULLPTR);

    QDateTime nextSunRise() const {return mNextSunRise;}
    QDateTime nextSunSet() const {return mNextSunSet;}
    QString location() const {return mLocation;}
    bool isDaylight() const {return mIsDaylight;}
    void connectToClient(KnutClient *knutClient);

    /*! This enum type describes the message types used to communicate with the Knut server via the
     *  KnutClient::writeRequest() as specified by the <a
     *  href="https://knut-server.readthedocs.io/en/latest/reference/knutapis.html#knut.apis.Local">
     *  Knut local API</a>.
     */
    enum MessageType {
        //! Requests the local information.
        LOCAL_REQUEST  = 0x0001,
        //! The local information send by the server.
        LOCAL_RESPONSE = 0x0101,
    };
    Q_ENUMS(MessageType)

signals:
    void isDaylightChanged();
    void locationChanged();
    void nextSunRiseChanged();
    void nextSunSetChanged();

public slots:
    void onKnutConnected();
    void onReadyRead(const QJsonObject &message, const quint8 &serviceId,
                     const quint16 &messageType);

private:
    KnutClient *mKnutClient;
    QDateTime mNextSunRise;
    QDateTime mNextSunSet;
    QString mLocation;
    bool mIsDaylight;
    const quint8 mServiceId = 0x04;
};

#endif // LOCAL_HPP
