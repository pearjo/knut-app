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
#ifndef TASK_HPP
#define TASK_HPP

#include <QDateTime>
#include <QObject>

#include "knutclient.hpp"

/*! \brief An implementation of the Knut task service.
 *
 *  This class implements the <a
 *  href="https://knut-server.readthedocs.io/en/latest/reference/knutservices.html#knutservices.Task">
 *  Knut task service</a> and communicates any changes through the KnutClient \a client to the Knut
 *  server.
 */
class Task : public QObject
{
    Q_OBJECT

    //! This property holds the assignee to the task.
    Q_PROPERTY(QString assignee READ assignee WRITE setAssignee NOTIFY assigneeChanged)

    //! This property holds the task's author.
    Q_PROPERTY(QString author MEMBER author CONSTANT)

    /*! This property holds the description text body of the task as <a
     *  href="https://commonmark.org/help/">CommonMark</a> plus the <a
     *  href="https://guides.github.com/features/mastering-markdown/">GitHub</a> extensions for
     *  tables and task lists.
     */
    Q_PROPERTY(QString body READ body WRITE setBody NOTIFY bodyChanged)

    //! This property describes whether the task is done or not.
    Q_PROPERTY(bool done READ done WRITE setDone NOTIFY doneChanged)

    //! This property holds the due date and time of the task.
    Q_PROPERTY(QDateTime due READ due WRITE setDue NOTIFY dueChanged)

    //! This property holds the Task::Due type of the Task.
    Q_PROPERTY(Due dueType READ dueType NOTIFY dueTypeChanged)

    //! This property holds the date and time when a reminder should be send.
    Q_PROPERTY(QDateTime reminder READ reminder WRITE setReminder NOTIFY reminderChanged)

    //! This property holds the title of the task.
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)

    //! This property holds the unique id of the task.
    Q_PROPERTY(QString uid MEMBER uid CONSTANT)

public:
    explicit Task(KnutClient *client, QObject *parent = Q_NULLPTR);

    //! This enum defines when the due date is relative to the current date.
    enum Due {
        //! the date is already past due.
        Overdue,
        //! the due date is today.
        Today,
        //! the due date is tomorrow.
        Tomorrow,
        //! the due date is within the current week.
        ThisWeek,
        //! the due date is at some date after the current week.
        Later
    };
    Q_ENUM(Due)

    QString author;
    QString uid;

    Due dueType() const {return mDueType;}
    QDateTime due() const {return mDue;}
    QDateTime reminder() const {return mReminder;}
    QString assignee() const {return mAssignee;}
    QString body() const {return mBody;}
    QString title() const {return mTitle;}
    bool done() const {return mDone;}

    void handleStatusResponse(const QJsonObject &message);
    void setAll(const QString &assignee, const QString &body, const bool &done, const int &due,
                const int &reminder, const QString &title);
    void setAssignee(const QString &assignee);
    void setBody(const QString &body);
    void setDone(const bool &done);
    void setDue(const QDateTime &due);
    void setReminder(const QDateTime &reminder);
    void setTitle(const QString &title);

signals:
    // property notifiers
    void assigneeChanged();
    void bodyChanged();
    void doneChanged();
    void dueChanged();
    void dueTypeChanged();
    void reminderChanged();
    void titleChanged();

    //! This signal is emitted when a reminder message is received from the Knut server.
    void remind();

private:
    void updateDueType();
    void statusChanged();

    Due mDueType = Due::Later;
    KnutClient *mKnutClient;
    QDateTime mDue;
    QDateTime mReminder;
    QString mAssignee;
    QString mBody;
    QString mTitle;
    bool mDone;
    const quint8 mServiceId = 0x03;
};

#endif // TASK_HPP
