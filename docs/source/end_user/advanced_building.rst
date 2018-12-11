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

CPP Cache
---------

If CPP is building a project's dependencies, CPP needs to install those
dependencies somewhere. While it at first may seem like a good idea to install
those dependencies alongside the project, this can be problematic depending on
where the dependency is being installed (for example if the project is being
installed to ``/usr/local``, it is easy for the dependency to be overwritten by
another project). Furthermore, dependencies built by CPP are special in that
CPP has a record of how they were configured and built. CPP uses this knowledge
to ensure reproducible builds. Either way, we have decided to install the
project's dependencies into what we call the CPP Cache.

As an end user there's only a couple things you need to know about the cache.
First, this is where the project's dependencies live. So if you delete/move the
cache you will likely break that project. Second, you can control the cache's
location by setting the CMake variable ``CPP_INSTALL_CACHE``. While CPP is still
in beta testing this variable defaults to a directory ``cpp_cache`` inside the
build directory. This is because the cache is not considered stable yet and such
a location minimizes the impact on other dependencies if the cache needs to be
deleted. Once CPP is released the intent is for this variable to default to
``${HOME}/.cpp_cache`` so that a single, persistent CPP cache is used for all
projects.
