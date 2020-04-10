#ifndef LIGHT_LIST_MODEL_HPP
#define LIGHT_LIST_MODEL_HPP

#include <QStandardItemModel>

enum LightModelRoles
{
    LocationRole = Qt::UserRole + 1,
    RoomRole = Qt::UserRole + 2,
    LightRole = Qt::UserRole + 3,
};

class LightListModel : public QStandardItemModel
{
    Q_OBJECT

public:
    LightListModel(QObject *parent = 0) : QStandardItemModel(parent) {}

protected:
    QHash<int, QByteArray> roleNames() const
    {
        QHash<int, QByteArray> m_roles;

        m_roles[LocationRole] = "location";
        m_roles[RoomRole] = "room";
        m_roles[LightRole] = "light";

        return m_roles;
    }
};

#endif // LIGHT_LIST_MODEL_HPP
