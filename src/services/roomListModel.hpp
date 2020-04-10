#ifndef ROOM_LIST_MODEL_HPP
#define ROOM_LIST_MODEL_HPP

#include <QStandardItemModel>

class RoomListModel : public QStandardItemModel
{
    Q_OBJECT

public:
    RoomListModel(QObject *parent = 0) : QStandardItemModel(parent) {}

    enum RoomModelRoles
    {
        RoomNameRole = Qt::UserRole + 1,
        RoomRole = Qt::UserRole + 2,
    };

protected:
    QHash<int, QByteArray> roleNames() const
    {
        QHash<int, QByteArray> m_roles;

        m_roles[RoomNameRole] = "roomName";
        m_roles[RoomRole] = "room";

        return m_roles;
    }
};

#endif // ROOM_LIST_MODEL_HPP
