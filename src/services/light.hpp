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
#ifndef LIGHT_HPP
#define LIGHT_HPP

#include <QColor>
#include <QObject>

#include "knutclient.hpp"

/*! \brief An implementation of the Knut light service.
 *
 *  This class implements the <a href="https://knut-server.readthedocs.io/en/latest/reference/knutservices.html#knutservices.Light">
 *  Knut light service</a> and communicates any changes through the KnutClient \a client to the Knut
 *  server.
 */
class Light : public QObject
{
    Q_OBJECT

    /// The current light color.
    Q_PROPERTY(QColor lightColor READ color WRITE setColor NOTIFY colorChanged)
    /// The hex color code that represents the light when the temperature is 0.
    Q_PROPERTY(QString colorCold MEMBER colorCold CONSTANT)
    /// The hex color code that represents the light when the temperature is 100.
    Q_PROPERTY(QString colorWarm MEMBER colorWarm CONSTANT)
    /// The location of the light inside the room.
    Q_PROPERTY(QString location MEMBER location CONSTANT)
    /// The room where the light is located.
    Q_PROPERTY(QString room MEMBER room CONSTANT)
    /// Whether the light has a light color or not.
    Q_PROPERTY(bool hasColor MEMBER hasColor CONSTANT)
    /// Whether the light can be dimmed or not.
    Q_PROPERTY(bool hasDimlevel MEMBER hasDimlevel CONSTANT)
    /// Whether the light has a light temperature or not.
    Q_PROPERTY(bool hasTemperature MEMBER hasTemperature CONSTANT)
    /// The current state of the light.
    Q_PROPERTY(bool lightState READ lightState WRITE setLightState NOTIFY lightStateChanged)
    /// The light temperature as a value in the range from \c 0 to \c 100 where \c 0 is cold and
    /// \c 100 warm.
    Q_PROPERTY(qint16 temperature READ temperature WRITE setTemperature NOTIFY temperatureChanged)
    /// The dim-level of the light in the range from \c 0 to \c 100 where \c 0 is off and \c 100
    /// full on.
    Q_PROPERTY(qint8 dimlevel READ dimlevel WRITE setDimlevel NOTIFY dimlevelChanged)

public:
    explicit Light(KnutClient *client, QObject *parent = Q_NULLPTR);

    QString colorCold;
    QString colorWarm;
    QString location;
    QString room;
    QString uniqueName;
    bool hasColor;
    bool hasDimlevel;
    bool hasTemperature;

    QColor color() const {return mColor;}
    bool lightState() const {return mLightState;}
    qint16 temperature() const {return mTemperature;}
    qint8 dimlevel() const {return mDimlevel;}

    void setAll(const bool &lightState, const qint16 &temperature, const qint8 &dimlevel,
                const QColor &color);
    void setColor(const QColor &color);
    void setDimlevel(const qint8 &dimlevel);
    void setLightState(const bool &lightState);
    void setTemperature(const qint16 &temperature);

    void handleStatusResponse(const QJsonObject &message);

signals:
    void locationChanged();
    void lightStateChanged();
    void temperatureChanged();
    void dimlevelChanged();
    void colorChanged();

private:
    void statusChanged();

    const quint8 mServiceId = 0x02;
    bool mLightState = false;
    qint16 mTemperature = false;
    qint8 mDimlevel = false;
    QColor mColor;
    KnutClient *mKnutClient;
};

#endif // LIGHT_HPP
