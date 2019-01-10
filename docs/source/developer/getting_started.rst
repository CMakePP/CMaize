.. _getting_started-label:

Getting Started With CPP
========================

This page is meant to provide perspective CPP developers with the "lay of the
land".

CPP CMake Module
----------------

CPP is written as a CMake module (actually a series of CMake modules). While the
CPP repo contains Python scripts, such scripts are used purely for developer
tasks (generating documentation for example) and are never called by CPP during
a run. All development affecting CPP's runtime behavior must honor this design
decision in order to avoid introducing additional dependencies. Development
activities targeting CPP developer tasks are free to use whatever programs and
languages are appropriate, although Python, where applicable, is strongly
preferred.

Primary API
-----------

Users of CPP interact with it by calling CPP functions from their project's
``CMakeLists.txt`` file. CPP exposes functions primarily concerned with:

- Setting up the CMake/CPP environments

  - :ref:`CPPMain-label`

- Finding/building dependencies

  - :ref:`cpp_find_dependency-label`
  - :ref:`cpp_find_or_build_dependency-label`

- Creating new libraries/executables

  - :ref:`cpp_add_library-label`
  - :ref:`cpp_add_executable-label`

- Installing and packaging the user's project

  - :ref:`cpp_install-label`

This covers the majority of a typical build. What it doesn't cover are build
tasks that are highly package specific such as computing optimized flags and/or
build settings, or handling user-specified options (user from the perspective of
the CPP user, *i.e.*, the person trying to build the package). Users of CPP are
free to codify such tasks in their ``CMakeLists.txt``, calling CPP as
appropriate (say for locating an optional dependency).

Typical Control Flow
--------------------

When CMake is called on a package that uses CPP, control originates in the
user's ``CMakeLists.txt``. They are free to do whatever they want, but typically
they will just use the following boilerplate:

.. code-block::cmake

    cmake_minimum_required(VERSION 3.12)
    project(name VERSION X.X.X)
    find_package(cpp REQUIRED)

CMake requires (well strongly suggests to the point of issuing warnings) that
all CMake projects start by calling CMake's ``cmake_minimum_required``. CMake
also requires that you declare a project by using CMake's ``project`` function.
CPP requires that ``project`` is called before CPP is used (internally we use
variables set by the ``project`` command to learn about what we're building).
The last line pulls CPP into scope using CMake's ``find_package`` command. This
is the entry point into CPP since it ultimately runs the script contained in
CPP's config file (the template for the config file is the file
``cpp-config.cmake.in`` located in the root directory of the CPP repo). Of
relevance it is during this call to ``find_package`` that ``CPPMain()`` is
invoked.

After the call to ``find_package(cpp)`` control is returned to the user. At this
point the user is free to use any CMake or CPP commands (which are now in
scope). Typically what the user will do next is declare the options their
package recognizes (these are options seen by the person building the package).
It is recommended that user's use ``cpp_option`` to do this, but it is not
required (``cpp_option`` just wraps common boilerplate for printing the option
to the log and ensuring that the option is only set to the default value if the
end user has not set it). After declaring the options, users will typically
declare dependencies. To get the most out of CPP these dependencies should be
registered with CPP by using either ``cpp_find_or_build_dependency`` or
``cpp_find_dependency``; however, if the user so chooses they can manually
invoke CMake's ``find_package`` command. Ultimately, all that CPP cares about
is that there is a target for each dependency and that those targets have all
fields (*e.g.*, include directories, link libraries, *etc.*) filled in
correctly. CPP assumes that the user's ``CMakeList.txt`` is accounting for any
conditional dependencies (*i.e.*, the user should be writing the ``if``
statements required to wrap the calls to the CPP dependency functions).

With dependencies taken care of all that remains is to create targets for the
libraries/executables that the user's package is actually building. Again this
can be done through the native CMake ``add_library`` and ``add_executable``
commands; however, it is recommended that users use CPP's wrapper functions as
they will take care of much of the boilerplate related to setting up the targets
given relatively little information. The CPP variants require that all
dependencies be provided as targets.

Finally, the user needs to set up the install phase. For full customization the
user can use CMake's ``install`` command; however, by this point the actual
installation can be relatively easily deduced from the various target's
properties. CPP's ``cpp_install`` command will leverage this fact, in turn
requiring nothing more than the names of the targets the user wants to install.
To summarize, control flow typically resides with the user being given to CPP
only by the following:

- ``find_package(cpp)``
- ``cpp_find_or_build_dependency``/``cpp_find_dependency``
- ``cpp_add_library``/``cpp_add_executable``
- ``cpp_install``
