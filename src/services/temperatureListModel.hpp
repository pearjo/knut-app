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
