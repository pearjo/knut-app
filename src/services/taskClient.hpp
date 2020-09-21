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
#ifndef TASK_CLIENT_HPP
#define TASK_CLIENT_HPP

#include <QJsonObject>
#include <QObject>
#include <QSortFilterProxyModel>
#include <QStandardItemModel>

#include "knutclient.hpp"
#include "task.hpp"

//! Handles all Task services.
class TaskClient : public QObject
{
    Q_OBJECT

    /*! This property holds the model of all tasks with the roles \c due and \c task where \c task
     *  references to a Task service.
     */
    Q_PROPERTY(QStandardItemModel *taskModel MEMBER taskModel NOTIFY taskModelChanged);

public:
    explicit TaskClient(QObject *parent = nullptr);
    ~TaskClient();

    QHash<QString, QObject *> tasks() const {return mTasks;}
    QStandardItemModel *taskModel {nullptr};
    Q_INVOKABLE void addTask(const QString &assignee, const QString &body, const QDateTime &due,
                             const QDateTime &reminder, const QString &title);
    Q_INVOKABLE void deleteTask(const QVariant &task);
    void connectToClient(KnutClient *knutClient);

    /*! This enum type describes the message types used to communicate with the Knut server via the
     *  KnutClient::writeRequest() as specified by the <a
     *  href="https://knut-server.readthedocs.io/en/latest/reference/knutapis.html#knut.apis.Task">
     *  Knut task API</a>.
     */
    enum MessageType {
        //! A reminder send by the server.
        REMINDER  = 1,
        //! Requests a task.
        TASK_REQUEST = 2,
        //! The task send by the server.
        TASK_RESPONSE = 3,
        //! Requests all tasks.
        ALL_TASKS_REQUEST = 4,
        //! The state of all Task services.
        ALL_TASKS_RESPONSE = 5,
        //! Requests to delete a Task.
        DELETE_TASK_REQUEST = 6,
    };
    Q_ENUMS(MessageType)

signals:
    void taskModelChanged();

public slots:
    void onKnutConnected();
    void onReadyRead(const QJsonObject &message, const quint8 &serviceId,
                     const quint16 &messageType);

private:
    void allTasksResponse(const QJsonObject &message);
    void reminder(const QJsonObject &message);
    void taskResponse(const QJsonObject &message);

    KnutClient *mKnutClient;
    QHash<QString, QObject *> mTasks;
    const quint8 mServiceId = 0x03;
};

#endif // TASK_CLIENT_HPP
