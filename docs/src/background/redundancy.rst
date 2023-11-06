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

Strictly speaking, CMake-based build systems can be pretty minimal. For example,
consider a C++ project, with no dependencies, which builds an executable from a
single source file. While the contents of the source file could be quite
complicated, we can illustrate this point with the very simple C++ executable:

.. literalinclude:: /../../tests/docs/bare_bones_cmake/hello_world.cpp
   :language: C++
   :lines: 17-22
   :linenos:
   :lineno-start: 1

To build our executable, the minimal ``CMakeLists.txt`` file looks like (we
assume the source file lives next to the ``CMakeLists.txt``):

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

.. literalinclude:: /../../tests/docs/warning_free_bare_bones/CMakeLists.txt
   :language: CMake
   :lines: 15-20
   :linenos:
   :lineno-start: 1
