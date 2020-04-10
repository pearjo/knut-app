#ifndef ROOM_HPP
#define ROOM_HPP

#include <QObject>

#include "../knutclient.hpp"

class Room : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString room MEMBER room CONSTANT);
    Q_PROPERTY(float roomState READ roomState WRITE setRoomState NOTIFY roomStateChanged);

  public:
    explicit Room(KnutClient *socket, QObject *parent = Q_NULLPTR);

    QString room;

    float roomState() const {return mRoomState;}

  signals:
    void roomStateChanged();

  public slots:
    void setRoomState(const float &roomState);
    void handleRoomResponse(const float &roomState);

  private:
    const quint8 mServiceId = 0x02;
    float mRoomState;
    KnutClient *mKnutClient;
};

#endif // ROOM_HPP
