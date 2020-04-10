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
#ifndef ROOM_HPP
#define ROOM_HPP

#include <QObject>

#include "../knutclient.hpp"

class Room : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString room MEMBER room CONSTANT);
    Q_PROPERTY(float roomState READ roomState WRITE setRoomState NOTIFY roomStateChanged);

  public:
    explicit Room(KnutClient *socket, QObject *parent = Q_NULLPTR);

    QString room;

    float roomState() const {return mRoomState;}

  signals:
    void roomStateChanged();

  public slots:
    void setRoomState(const float &roomState);
    void handleRoomResponse(const float &roomState);

  private:
    const quint8 mServiceId = 0x02;
    float mRoomState;
    KnutClient *mKnutClient;
};

#endif // ROOM_HPP
