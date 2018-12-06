.. _advanced_building-label:

Advanced Building
=================

While CPP strives to make building a project easy, power users and developers
will likely want more control over the project they are building.

.. _toolchains-label:

Toolchains
----------

These files are forwarded to CMake via the ``CMAKE_TOOLCHAIN_FILE`` variable.
Particularly when you are setting a lot of options for CMake these files can
come in handy.  Basically they look like:

.. code-block:: cmake

   set(OPTION1 VALUE1)
   set(OPTION2 VALUE2)

That is they're just a large number of CMake ``set`` commands.  Internally CPP
uses a toolchain file to forward options to dependencies.  This file is located
at ``build/directory/toolchain.cmake``.  Running CMake on a CPP project with no
arguments is a great way to generate a template toolchain file.

Say we have a project ``foo`` with a dependency ``bar``.  Furthermore,
assume that ``bar``'s configuration recognizes an option ``bar_option``.
Configuring ``foo`` with ``-Dbar_option`` will not forward the option to
``bar``.  How CMake's variables work is a highly technical topic, but suffice
it to say there is no robust way for CPP to determine you set ``bar_option`` on
the command line.  Thus there's no way for CPP to automatically forward this
option to ``bar`` for you.  The only way to guarantee that ``bar_option`` is
forwarded is to add it to your toolchain file.
