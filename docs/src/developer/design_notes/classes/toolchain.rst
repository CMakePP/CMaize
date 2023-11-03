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

***************
Toolchain Class
***************

Users need a way to specify options which should be passed to every
dependency. By convention this is done by setting the options in a toolchain
file. The ``Toolchain`` class is the source code representation of 
this file, containing values autopopulated by CMaize, as well as
user-specified options. User options take precidence over autopopulated
values.

Usage
-----

The ``Toolchain`` class can create a toolchain file containing both the
autopopulated and user-provided toolchain options, with user-provided
options taking precidence. This generated toolchain file is written to
disk with the ``write_toolchain`` method and should be included by the
user to apply it. The ``CMAKE_TOOLCHAIN_FILE`` argument should be used
to pass the toolchain to CMake commands.

Autopopulated Values
--------------------

Certain variables are autopopulated with default values by CMaize. These
autopopulated values will be overridden if a user-specified toolchain file
also assigns a value to the variable. The 
``_CMAIZE_TOOLCHAIN_AUTOPOPULATED_VARIABLE_NAMES`` list variable can be
printed with the following in your ``CMakeLists.txt file`` after including
CMaize:

.. code:: cmake

   message("Autopopulated variables: ${_CMAIZE_TOOLCHAIN_AUTOPOPULATED_VARIABLE_NAMES}")

or, for a multiline list:

.. code:: cmake

   message("Autopopulated variables:")
   foreach(var_name ${_CMAIZE_TOOLCHAIN_AUTOPOPULATED_VARIABLE_NAMES})
      message("  ${var_name}")
   endforeach()
