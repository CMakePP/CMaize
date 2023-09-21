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

************************
CXX Build Target Classes
************************

The ``CXXTarget`` class contains much of the process of building a
CXX target, except for the creation of the different target types (for 
example, CMake's ``add_library()`` vs ``add_executable()`` calls).
``CXXTarget`` is the common parent class for the concrete CXX build targets,
``CXXLibrary``, ``CXXInterfaceLibrary``, and ``CXXExecutable``.

Usage
=====

The concrete build target classes, ``CXXLibrary``, ``CXXInterfaceLibrary``,
and ``CXXExecutable`` should be instantiated with unique target name
strings. Once instantiated, a call to ``CXXTarget(make_target`` will set
up the target with desired properties provided as optional, named parameters.
A list of all parameter options can be found in the function documentation
for ``CXXTarget(make_target``.

For example, a CXX library with known lists of source and include files that
specifically uses the CXX 14 standard can be specified as follows:

.. code-block:: CMake
   
   include(cmaize/cmaize)

   # Create a list of include files
   list(APPEND include_files
       include/example_file_1.hpp
       include/example_file_2.hpp
       include/example_dir/example_file_3.hpp
   )

   # Create a list of source code files
   list(APPEND source_files
       src/example_file_1.cpp
       src/example_file_2.cpp
       src/example_dir/example_file_3.cpp
   )

   # Create a CXX library object named "example_library_name"
   CXXLibrary(CTOR lib_obj example_library_name)

   # Call ``CXXTarget(make_target`` with optional parameters INCLUDES,
   # SOURCES, and CXX_STANDARD to provide include files, source files, and
   # the specific CXX standard to use when building this target.
   CXXLibrary(make_target
       "${lib_obj}"
       INCLUDES "${include_files}"
       SOURCES "${source_files}"
       CXX_STANDARD 14
   )
