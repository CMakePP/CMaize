#######################################
Redundancy in CMake-Based Build Systems
#######################################

One of the predicates underlying the :ref:`statement_of_need` section is that
CMake-based build systems are redundant. The redundancy in turn contributes to
the verboseness of the resulting build system, and its inability to satisfy
:term:`DRY`. To better illustrate this point the present page showcases some
example CMake-based build systems. Note source for all examples are available in
CMaize's GitHub repository in the ``tests/docs`` directory.

******************************
Bare-Minium CMake Build System
******************************

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
resulting executable, but it will build and the executable will work. If we
want to be warning free we need to expand the ``CMakeLists.txt`` to:

.. literalinclude:: /../../tests/docs/warning_free_bare_bones/CMakeLists.txt
   :language: CMake
   :lines: 15-18
   :linenos:
   :lineno-start: 1

and if we also want to be able to install the executable the minimal
``CMakeLists.txt`` is then:

.. literalinclude:: /../../tests/docs/minimal_cmake/CMakeLists.txt
   :language: CMake
   :lines: 15-20
   :linenos:
   :lineno-start: 1

In our opinion, the above is a reasonable candidate for the "simplest"
CMake-based build system for our simple C++ project. The above project should
be ``

The build system does not
however, adhere to best practices. In particular, the installed project should
provide package configuration files

***************************************
Realistic Bare-Bones CMake Build System
***************************************
