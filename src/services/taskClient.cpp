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
#include "taskListModel.hpp"

#include <QJsonArray>

TaskClient::TaskClient(QObject *parent) :
    QObject(parent)
{
    taskModel = new TaskListModel(this);
    taskModel->clear();
    taskModel->setSortRole(TaskListModel::DueRole);
}

TaskClient::~TaskClient()
{
    delete taskModel;
    qDeleteAll(mTasks);
}

/*! \brief Add a new task.
 *
 *  Sends a request to the Knut server to create a new task with an \a assignee, \a description \a
 *  body, a \a due date, \a reminder and a \a title.
 *
 *  \b Note: This function can be invoked via the meta-object system and from QML.
 */
void TaskClient::addTask(const QString &assignee, const QString &body, const QDateTime &due,
                         const QDateTime &reminder, const QString &title)
{
    QJsonObject newTask;

    newTask[QStringLiteral("assignee")] = assignee;
    newTask[QStringLiteral("body")] = body;
    newTask[QStringLiteral("done")] = false;
    newTask[QStringLiteral("due")] = due.toSecsSinceEpoch();
    newTask[QStringLiteral("reminder")] = due.toSecsSinceEpoch() - reminder.toSecsSinceEpoch();
    newTask[QStringLiteral("title")] = title;
    newTask[QStringLiteral("id")] = QStringLiteral("");

    mKnutClient->writeRequest(newTask, mServiceId, TaskClient::TASK_RESPONSE);
}

/*! \brief Connects to the KnutClient \a knutClient.
 *
 *  Connects the onKnutConnected() slot to the KnutClient::knutConnected() signal and the
 *  onReadyRead() slot to the signal KnutClient::receivedMessage() signal.
 */
void TaskClient::connectToClient(KnutClient *knutClient)
{
    mKnutClient = knutClient;

    connect(mKnutClient, &KnutClient::knutConnected, this, &TaskClient::onKnutConnected);
    connect(mKnutClient, &KnutClient::receivedMessage, this, &TaskClient::onReadyRead);

    if (mKnutClient->connected)
        onKnutConnected();
}

/*! \brief Sends a request to delete a \a task.
 *
 *  \b Note: This function can be invoked via the meta-object system and from QML.
 */
void TaskClient::deleteTask(const QVariant &task)
{
    QJsonObject message;

    Task *knutTask = qvariant_cast<Task *>(task);

    if (knutTask == nullptr)
        return;

    message[QStringLiteral("id")] = knutTask->uid;

    mKnutClient->writeRequest(message, mServiceId, TaskClient::MessageType::DELETE_TASK_REQUEST);
}

void TaskClient::onKnutConnected()
{
    mKnutClient->writeRequest(mServiceId, TaskClient::MessageType::ALL_TASKS_REQUEST);
}

/*! \brief Slot called when a \a message is available.
 *
 *  If a message is received by the KnutClient, this slot is called. If the \a serviceId
 *  is \c 0x03, a corresponding response handle method is called for the \a messageType.
 *
 *  \sa TaskClient::MessageType
 */
void TaskClient::onReadyRead(const QJsonObject &message, const quint8 &serviceId,
                             const quint16 &messageType)
{
    if (serviceId != mServiceId)
        return;

    switch (messageType) {
        case TaskClient::MessageType::REMINDER: {
            reminder(message);
            break;
        }
        case TaskClient::MessageType::TASK_RESPONSE: {
            taskResponse(message);
            break;
        }
        case TaskClient::MessageType::ALL_TASKS_RESPONSE: {
            allTasksResponse(message);
            break;
        }
        default:
            break;
    }
}

//! Handles a TaskClient::ALL_TASKS_REQUEST.
void TaskClient::allTasksResponse(const QJsonObject &message)
{
    taskModel->clear();
    mTasks.clear();

    QJsonArray tasks = message["tasks"].toArray();

    // for (QString task : message.keys()) {
    for (int i = 0; i < tasks.size(); ++i) {
        const QJsonObject taskDict = tasks[i].toObject();
        Task *newTask = new Task(mKnutClient);

        newTask->uid = taskDict["id"].toString();
        newTask->author = taskDict["author"].toString();

        newTask->setAll(taskDict["assignee"].toString(),
                        taskDict["body"].toString(),
                        taskDict["done"].toBool(),
                        taskDict["due"].toInt(),
                        taskDict["reminder"].toInt(),
                        taskDict["title"].toString());

        mTasks.insert(newTask->uid, newTask);

        QStandardItem *taskItem = new QStandardItem;
        taskItem->setData(newTask->due().toSecsSinceEpoch(), TaskListModel::DueRole);
        taskItem->setData(newTask->dueType(), TaskListModel::DueTypeRole);
        taskItem->setData(QVariant::fromValue(newTask), TaskListModel::TaskRole);
        taskModel->appendRow(taskItem);
    }

    taskModel->sort(0);
    emit taskModelChanged();
}

//! Handles a TaskClient::REMINDER message.
void TaskClient::reminder(const QJsonObject &message)
{
    const QString uid = message["id"].toString();
    Task *task = static_cast<Task *>(mTasks[uid]);

    emit task->remind();
}

//! Handles a TaskClient::TASK_RESPONSE.
void TaskClient::taskResponse(const QJsonObject &message)
{
    const QString uid = message["id"].toString();
    Task *task = static_cast<Task *>(mTasks[uid]);

    task->setAll(message["assignee"].toString(),
                 message["body"].toString(),
                 message["done"].toBool(),
                 message["due"].toInt(),
                 message["reminder"].toInt(),
                 message["title"].toString());

    // update the task model
    for (int i = 0; i < taskModel->rowCount(); ++i) {
        if (taskModel->item(i)->data(TaskListModel::TaskRole) == QVariant::fromValue(task)) {
            taskModel->item(i)->setData(task->due().toSecsSinceEpoch(), TaskListModel::DueRole);
            taskModel->item(i)->setData(task->dueType(), TaskListModel::DueTypeRole);

            taskModel->sort(0);
            emit taskModelChanged();
        }
    }
}
