.. _temperatureservice:

Temperature Service
===================

The Knut temperature service is represented by the :cpp:class:`Temperature`
object. The incoming communication from the server is handled by the
:cpp:class:`TemperatureClient` which calls a corresponding handler method for
each message type. The temperature object it self can only read data from the
server and can not change the temperature (... that would be an awesome
feature).

.. doxygenclass:: Temperature
   :project: knut-app
   :members:

.. doxygenclass:: TemperatureClient
   :project: knut-app
   :members:
