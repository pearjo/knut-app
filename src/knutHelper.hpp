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
#ifndef KNUT_HELPER_HPP
#define KNUT_HELPER_HPP

#include <QDateTime>
#include <QTimer>

/*! \brief KnutHelper provides some convenient functions useful for QML items.
 *
 *  This class provides some functions which are useful to use in QML items to shift work load
 *  to the C++ side of the application.
 */
class KnutHelper : public QObject
{
    Q_OBJECT

public:
    explicit KnutHelper(QObject *parent = nullptr);
    ~KnutHelper();

    //! This property describes whether a light or dark app theme should be used.
    Q_PROPERTY(bool light READ light NOTIFY lightChanged)

    /*! \brief This property holds the current system time.
     *
     *  Note that the time is updated only every seconds and is therefore not very precise.
     */
    Q_PROPERTY(QDateTime time READ time NOTIFY timeChanged)

    bool light() const {return mLight;}
    QDateTime time() const {return mTime;}
    static Q_INVOKABLE QString formatDateTime(const QDateTime &dateTime, const QString &format);
    static Q_INVOKABLE QString toStringFromSecs(const int &s, const QString &format);

signals:
    void lightChanged();
    void timeChanged();

private slots:
    void mOnTimer();

private:
    bool mLight = false;
    QDateTime mTime;
    QTimer *mTimer;
};

#endif // KNUT_HELPER_HPP
