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

private:
    quint8 mServiceId = 0x01;
};

#endif // TEMPERATURE_HPP
