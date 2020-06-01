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
#ifndef TEMPERATURE_HPP
#define TEMPERATURE_HPP

#include <QObject>
#include <QString>
#include <QVector>

class Temperature : public QObject
{
    Q_OBJECT
    /*! The code point for the current of the
     *  <a href="https://erikflowers.github.io/weather-icons/">weather icon</a>.
     */
    Q_PROPERTY(QString condition MEMBER condition NOTIFY conditionChanged)
    //! The location where the temperature is measured.
    Q_PROPERTY(QString location MEMBER location NOTIFY locationChanged)
    //! The temperature in degree Celsius.
    Q_PROPERTY(qreal temperature MEMBER temperature NOTIFY temperatureChanged)
    //! The unit symbol in which the temperature is given.
    Q_PROPERTY(QString unit MEMBER unit NOTIFY unitChanged)
    //! The time points matching the temperatureHistory in milliseconds since the epoch January 1,
    //! 1970, 00:00:00 (UTC).
    Q_PROPERTY(QVector<qint64> timeHistory MEMBER timeHistory NOTIFY timeHistoryChanged)
    //! The temperature history matching the timeHistory.
    Q_PROPERTY(QVector<qreal> temperatureHistory MEMBER temperatureHistory
               NOTIFY temperatureHistoryChanged)

public:
    explicit Temperature(QObject *parent = Q_NULLPTR) : QObject(parent) {}

    QString condition;
    QString location;
    QString uniqueName;
    QString unit;
    QVector<qint64> timeHistory;
    QVector<qreal> temperatureHistory;
    qreal temperature;

signals:
    void conditionChanged();
    void locationChanged();
    void temperatureChanged();
    void timeHistoryChanged();
    void temperatureHistoryChanged();
    void unitChanged();
};

#endif // TEMPERATURE_HPP
