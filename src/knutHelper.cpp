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
#include <QDebug>
#include "knutHelper.hpp"

KnutHelper::KnutHelper(QObject *parent) :
    QObject(parent),
    mTime(QDateTime::currentDateTime())
{
    // set time timer to increase the time
    mTimer = new QTimer(this);
    mTimer->setInterval(1000);
    connect(mTimer, SIGNAL(timeout()), this, SLOT(mOnTimer()));
    mTimer->start();
}

KnutHelper::~KnutHelper()
{
    delete mTimer;
}

/*! \brief Returns the \a dateTime as string formatted in \a format.
 *
 *  Note that this method is a wrapper for the QDateTime::toString() method. For more details on
 *  \a format please see QDateTime::toString().
 *
 *  Note that this method is invokable from QML.
 *
 *  \sa QDateTime::toString()
 */
QString KnutHelper::formatDateTime(const QDateTime &dateTime, const QString &format)
{
    return dateTime.toString(format);
}

/*! \brief Returns the \a s seconds as string formatted in \a format.
 *
 *  Converts the seconds \a s into a QTime and formats it using QTime::toString(). For \a format
 *  options please see QTime::toString().
 *
 *  Note that this method is invokable from QML.
 *
 *  \sa QTime::toString()
 */
QString KnutHelper::toStringFromSecs(const int &s, const QString &format)
{
    return QTime(0, 0).addSecs(s).toString(format);
}

void KnutHelper::mOnTimer()
{
    mTime = QDateTime::currentDateTime();
    mTimer->start();
    emit timeChanged();
}
