.. _lightservice:

Light Service
=============

The Knut light service is represented by the :cpp:class:`Room` and
:cpp:class:`Light` objects. Each light is assigned to a room and can therefore
be overwritten by this room. The incoming communication from the server is
handled by the :cpp:class:`LightClient` which calls a corresponding handler
method. Each light however can communicate directly with the
:cpp:class:`KnutClient` and therefore with the Knut server. The all light state
and room states are updated by the feedback loop from the server.

.. doxygenclass:: Light
   :project: knut-app
   :members:

.. doxygenclass:: LightClient
   :project: knut-app
   :members:

.. doxygenclass:: Room
   :project: knut-app
   :members:
