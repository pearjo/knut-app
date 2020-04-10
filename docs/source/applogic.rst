.. _applogic:

App Logic
=========

The logic of the Knut app communicates with the `Knut Server
<https://github.com/pearjo/knut-server>`_ via TCP and provides all information
received from the server as properties which can be used in the QML part of the
app aka `The App UI`. At the heart of the app's logic is the :ref:`knutclient`
which is used by each service to communicate to the server. Each service in the
server can be accessed via a dedicated API to which the :ref:`knutclient` sends
a JSON formatted message string. Read the `API documentations
<https://knut-server.readthedocs.io/en/latest/reference/knutapis.html>`_ for
more information about the message format of each service.

.. toctree::
   :maxdepth: 2
   :caption: Code Documentation

   reference/knutclient
   reference/lightservice
   reference/temperatureservice
