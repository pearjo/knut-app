.. _localservice:

Local Service
=============

The Local service is a unique service in the way, that it has now service client
like the :cpp:class:`TaskClient` for the :cpp:class:`Task` service. This is
because the local service holds only information for one location e.g. the
location where your home is.

.. doxygenclass:: Local
   :project: knut-app
   :members:
