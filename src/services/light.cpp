#include "light.hpp"
#include "lightClient.hpp"

Light::Light(KnutClient *client,  QObject *parent) : QObject(parent)
{
    mKnutClient = client;
}

/*! \brief Sets all properties of the Light at once.
 *
 *  Sets the \a lightState, \a temperature, \a dimlevel and \a color at once.
 */
void Light::setAll(const bool &lightState, const qint16 &temperature, const qint8 &dimlevel,
                   const QColor &color)
{
    if (mLightState != lightState) {
        mLightState = lightState;
        emit lightStateChanged();
    }

    if (hasTemperature && mTemperature != temperature) {
        mTemperature = temperature;
        emit temperatureChanged();
    }

    if (hasDimlevel && mDimlevel != dimlevel) {
        mDimlevel = dimlevel;
        emit dimlevelChanged();
    }

    if (hasColor && mColor != color) {
        mColor = color;
        emit colorChanged();
    }
}

void Light::setColor(const QColor &color)
{
    if ((mColor == color) || !hasColor)
        return;

    mColor = color;
    statusChanged();

    emit colorChanged();
}

void Light::setDimlevel(const qint8 &dimlevel)
{
    if ((mDimlevel == dimlevel) || !hasDimlevel)
        return;

    mDimlevel = dimlevel;
    statusChanged();

    emit dimlevelChanged();
}

void Light::setLightState(const bool &lightState)
{
    if (mLightState == lightState)
        return;

    mLightState = lightState;
    statusChanged();

    emit lightStateChanged();
}

void Light::setTemperature(const qint16 &temperature)
{
    if ((mTemperature == temperature) || !hasTemperature)
        return;

    mTemperature = temperature;
    statusChanged();

    emit temperatureChanged();
}

/*! \brief Handles a status response for a Light.
 *
 *  Applies the new status parsed by the \a message to the Light. The JSON \a message must contain
 *  the keys \c state, \c temperature \c dimlevel and \c color.
 *
 *  \sa LightClient::STATUS_RESPONSE
 */
void Light::handleStatusResponse(const QJsonObject & message)
{
    bool state = message["state"].toBool();
    quint16 temperature = message["temperature"].toInt();
    quint8 dimlevel = message["dimlevel"].toInt();
    QColor color = message["color"].toString();

    if (mLightState != state) {
        mLightState = state;
        emit lightStateChanged();
    }

    if (hasTemperature && mTemperature != temperature) {
        mTemperature = temperature;
        emit temperatureChanged();
    }

    if (hasDimlevel && mDimlevel != dimlevel) {
        mDimlevel = dimlevel;
        emit dimlevelChanged();
    }

    if (hasColor && mColor != color) {
        mColor = color;
        emit colorChanged();
    }
}

//! \brief Sends the current status as LightClient::STATUS_RESPONSE to the Knut server.
void Light::statusChanged()
{
    QJsonObject status;
    status["hasColor"] = hasColor;
    status["hasDimlevel"] = hasDimlevel;
    status["hasTemperature"] = hasTemperature;
    status["location"] = location;
    status["state"] = mLightState;
    status["uniqueName"] = uniqueName;

    // optional attributes
    status["color"] = hasColor ? mColor.name() : QString();
    status["colorCold"] = hasTemperature ? colorCold : QString();
    status["colorWarm"] = hasTemperature ? colorWarm : QString();
    status["dimlevel"] = hasDimlevel ? mDimlevel : qint8();
    status["temperature"] = hasTemperature ? mTemperature : qint16();

    mKnutClient->writeRequest(status, mServiceId, LightClient::STATUS_RESPONSE);
}
