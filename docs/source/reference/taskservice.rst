.. _taskservice:

Task Service
============

The Knut task service is represented by the :cpp:class:`Task`
object. The incoming communication from the server is handled by the
:cpp:class:`TaskClient` which calls a corresponding handler method for
each message type.

.. doxygenclass:: Task
   :project: knut-app
   :members:

.. doxygenclass:: TaskClient
   :project: knut-app
   :members:
