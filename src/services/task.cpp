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
#include "task.hpp"
#include "taskClient.hpp"

Task::Task(KnutClient *client,  QObject *parent) : QObject(parent)
{
    mKnutClient = client;
}

/*! \brief Handles a task response.
 *
 *  Applies the new status parsed by the \a message to the Task.
 *
 *  \sa TaskClient::TASK_RESPONSE
 */
void Task::handleStatusResponse(const QJsonObject & message)
{
    QString assignee = message["assignee"].toString();
    QString body = message["body"].toString();
    QString title = message["title"].toString();
    bool done = message["done"].toBool();
    int due = message["due"].toInt();
    int reminder = message["reminder"].toInt();

    if (!uid.isEmpty() && uid != message["id"].toString())
        return;

    author = message["author"].toString();
    setAll(assignee, body, done, due, reminder, title);
}

void Task::setAll(const QString &assignee, const QString &body, const bool &done, const int &due,
                  const int &reminder, const QString &title)
{
    if (mAssignee != assignee) {
        mAssignee = assignee;
        emit assigneeChanged();
    }

    if (mBody != body) {
        mBody = body;
        emit bodyChanged();
    }

    if (mDone != done) {
        mDone = done;
        emit doneChanged();
    }

    QDateTime dueDateTime = QDateTime::fromSecsSinceEpoch(due);
    if (mDue != dueDateTime) {
        mDue = dueDateTime;
        emit dueChanged();

        updateDueType();
    }

    if (mTitle != title) {
        mTitle = title;
        emit titleChanged();
    }

    QDateTime reminderDateTime = QDateTime::fromSecsSinceEpoch(due - reminder);
    if (mReminder != reminderDateTime) {
        mReminder = reminderDateTime;
        emit reminderChanged();
    }
}

void Task::setAssignee(const QString &assignee)
{
    if (mAssignee == assignee)
        return;

    mAssignee = assignee;
    assigneeChanged();
    statusChanged();
}

void Task::setBody(const QString &body)
{
    if (mBody == body)
        return;

    mBody = body;
    bodyChanged();
    statusChanged();
}

void Task::setDone(const bool &done)
{
    if (mDone == done)
        return;

    mDone = done;
    doneChanged();
    statusChanged();
}

void Task::setDue(const QDateTime &due)
{
    if (mDue == due)
        return;

    mDue = due;
    dueChanged();
    updateDueType();
    statusChanged();
}

void Task::setReminder(const QDateTime &reminder)
{
    if (mReminder == reminder)
        return;

    mReminder = reminder;
    reminderChanged();
    statusChanged();
}

void Task::setTitle(const QString &title)
{
    if (mTitle == title)
        return;

    mTitle = title;
    titleChanged();
    statusChanged();
}

//! Updates the dueType according to the current date.
void Task::updateDueType()
{
    QDate today = QDate::currentDate();
    Due dueType = Due::Later;

    if (mDue.date().year() == today.year()) {
        if (mDue.date().dayOfYear() < today.dayOfYear()) {
            dueType = Due::Overdue;
        } else if (mDue.date().dayOfYear() == today.dayOfYear()) {
            dueType = Due::Today;
        } else if (mDue.date().dayOfYear() == today.dayOfYear() + 1) {
            dueType = Due::Tomorrow;
        } else if (mDue.date().weekNumber() == today.weekNumber()) {
            dueType = Due::ThisWeek;
        }
    }

    if (mDueType != dueType) {
        mDueType = dueType;
        emit dueTypeChanged();
    }
}

//! Sends the current status as TaskClient::TASK_RESPONSE to the Knut server.
void Task::statusChanged()
{
    QJsonObject status;

    status["assignee"] = mAssignee;
    status["body"] = mBody;
    status["done"] = mDone;
    status["due"] = mDue.toSecsSinceEpoch();
    status["reminder"] = mDue.toSecsSinceEpoch() - mReminder.toSecsSinceEpoch();
    status["title"] = mTitle;
    status["id"] = uid;

    mKnutClient->writeRequest(status, mServiceId, TaskClient::TASK_RESPONSE);
}
