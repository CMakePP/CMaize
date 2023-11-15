.. Copyright 2023 CMakePP
..
.. Licensed under the Apache License, Version 2.0 (the "License");
.. you may not use this file except in compliance with the License.
.. You may obtain a copy of the License at
..
.. http://www.apache.org/licenses/LICENSE-2.0
..
.. Unless required by applicable law or agreed to in writing, software
.. distributed under the License is distributed on an "AS IS" BASIS,
.. WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
.. See the License for the specific language governing permissions and
.. limitations under the License.

#######################################
Redundancy in CMake-Based Build Systems
#######################################

One of the predicates underlying the :ref:`statement_of_need` section is that
CMake-based build systems are redundant. The redundancy in turn contributes to
the verboseness of the resulting build system, and its inability to satisfy
:term:`DRY`. To better illustrate this point, this page showcases some
example CMake-based build systems. Note that source code for all examples are available in
CMaize's GitHub repository in the ``tests/docs`` directory.

.. _bare_minimum_cmake_build_system:

*******************************
Bare-Minimum CMake Build System
*******************************

Defining the "minimal CMake-based build system" is a seemingly innocuous task.
In theory, we are after the shortest CMake script which will build a simple C++
project. In practice, the shortest CMake script will depend on exactly what we
mean by "build" and what constitutes a "simple" C++ project. The latter is
perhaps easier to define. To that end, consider a C++ project which has no
dependencies (aside from the standard C++ library) and let the project build
a single executable from a single source file. The complexity of the contents of
the source file are irrelevant, so long as the contents adhere to the stated
assumptions; thus a standard "Hello World" example suffices:

.. literalinclude:: /../../tests/docs/bare_bones_cmake/hello_world.cpp
   :language: C++
   :lines: 17-22
   :linenos:
   :lineno-start: 1

Assuming the above source code resides in a source file ``hello_world.cpp``,
which resides next to the ``CMakeLists.txt`` for building it, i.e., assuming a
project structure like:

.. code-block::

   hello_world/
   ├─ CMakeLists.txt
   ├─ hello_world.cpp


then the minimal ``CMakeLists.txt`` file looks like:

.. literalinclude:: /../../tests/docs/bare_bones_cmake/CMakeLists.txt
   :language: CMake
   :lines: 15
   :linenos:
   :lineno-start: 1

Note this will not configure warning free, nor will you be able to install the
resulting executable. If we want to be warning free we need to expand the
``CMakeLists.txt`` to:

.. literalinclude:: /../../tests/docs/warning_free_bare_bones/CMakeLists.txt
   :language: CMake
   :lines: 15-18
   :linenos:
   :lineno-start: 1

and if we also want to be able to install the executable, the minimal
``CMakeLists.txt`` is then:

.. literalinclude:: /../../tests/docs/minimal_cmake/CMakeLists.txt
   :language: CMake
   :lines: 15-20
   :linenos:
   :lineno-start: 1

In our opinion, the above is a reasonable candidate (*vide infra*) for the
"simplest" CMake-based build system for our simple C++ project. Of note the
build system:

- is warning free,
- builds the executable,
- installs the executable,
- is configurable (it respects variables meant to be set by the user,
  like ``CMAKE_INSTALL_PREFIX`` and ``CMAKE_CXX_FLAGS``), and
- can be included by other CMake-based build systems via CMake's
  ``FetchContent`` module.

The "candidate" moniker is because this build system still does not adhere to
all CMake best practices. In particular, the installed package does not provide
CMake configuration files to facilitate finding the package with CMake's
``find_package`` function. To be fair, such files are far more important for
libraries which are meant to be consumed by other (CMake-based) build systems.
Thus, whether the CMake-based build system here needs to generate configuration
files is up for debate. Nevertheless, for completeness, we can also generate the
configuration files by using the ``CMakeLists.txt``:

.. literalinclude:: /../../tests/docs/bp_minimal_cmake/CMakeLists.txt
   :language: CMake
   :lines: 15-70
   :linenos:
   :lineno-start: 1

CMake also requires us to write a template configuration file, i.e., a
``<project-name>-config.cmake.in`` file. The contents of our
``hello_world-config.cmake.in`` file is:

.. literalinclude:: /../../tests/docs/bp_minimal_cmake/hello_world-config.cmake.in
   :lines: 15-21
   :linenos:
   :lineno-start: 1

As can be seen, needing to generate configuration files dramatically lengthens
the build system. However, as we tried to show in the above snippets by
the use of variables, most of of the required code is :term:`boilerplate`. It
should be noted, this boilerplate was adopted from CMake's official
importing/exporting guide :cite:`official_import_export`; the point being, if
there is a more succinct way to package an executable, CMake is not currently
advertising it (and we are not aware of it).

Some readers may argue that this is still not the "simplest CMake-based build
system" because the build system still does not address a number of software
development best practices, e.g., documentation, testing, and/or deployment.
While there are benefits which come from integrating these tasks into the build
system (mainly the ability to utilize configuration information), many of these
remaining tasks are conventionally handled by tools outside CMake (though CMake
may provide support for these tools, e.g., via CTest or the Doxygen CMake
module). Regardless of what exactly constitutes the "simplest CMake-based build
system", already with the previous example we have begun to see redundancy.
The vast majority of the boilerplate could have been filled in for the
developer provided the:

- name of the target to install,
- the name of the project, and
- the project version.

Furthermore, the latter two on the list are available from CMake as long as the
developer calls the ``project()`` command with a version.

Bare-Minimum CMaize Build System
=================================

.. note::

   Since CMaize is a CMake extension, its location is not known to CMake by
   default. CMaize examples on this page assume that the build system knows
   where CMaize is located. There are a number of ways to accomplish this
   (see :ref:`obtaining_cmaize`).

We would be remiss if we did not take this opportunity to demonstrate what the
equivalent CMaize-based build system looks like. Said build system is:

.. literalinclude:: /../../tests/docs/minimal_cmaize/CMakeLists.txt
   :lines: 15-21
   :linenos:
   :lineno-start: 1

It should be noted that the above CMaize-based build system:

- is warning free,
- builds the executable,
- installs the executable,
- is configurable (it respects variables meant to be set by the user,
  like ``CMAKE_INSTALL_PREFIX`` and ``CMAKE_CXX_FLAGS``),
- can be included by other CMake-/CMaize-based build systems via CMake's
  ``FetchContent`` module, and
- will generate the configuration files necessary for another CMake-/CMaize-
  based build system to leverage an installed version.

Admittedly the brevity of the CMaize-based build system comes from making a
number of assumptions about default values (see :ref:`cmaize_assumptions` for
a full list). However, we expect that these assumptions are already true for
the majority of CMake-based projects and/or most projects would be fine adopting
these conventions in exchange for the much simpler build system.
