#ifndef TEMPERATURE_LIST_MODEL_HPP
#define TEMPERATURE_LIST_MODEL_HPP

#include <QStandardItemModel>

class TemperatureListModel : public QStandardItemModel
{
    Q_OBJECT

public:
    TemperatureListModel(QObject *parent = 0) : QStandardItemModel(parent) {}

    enum TemperatureModelRoles
    {
        LocationRole = Qt::UserRole + 1,
        TemperatureRole = Qt::UserRole + 2,
    };

protected:
    QHash<int, QByteArray> roleNames() const
    {
        QHash<int, QByteArray> m_roles;

        m_roles[LocationRole] = "location";
        m_roles[TemperatureRole] = "temperature";

        return m_roles;
    }
};

#endif // TEMPERATURE_LIST_MODEL_HPP
