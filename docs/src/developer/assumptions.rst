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

.. _cmaize_assumptions:

##################
CMaize Assumptions
##################

Compared to CMake's :term:`API`, CMaize has a vastly simpler API.
CMake's verbose API originates from CMake's philosophy of making every detail
configurable, even when modifying those details would: create inconsistencies
throughout the project (e.g., claiming a target gets installed somewhere it
does not), are against best practices (e.g., not namespace protecting an
imported target), not follow widely adhered to conventions (e.g.,
putting the source for more than one target in the same directory).
CMaize's simpler API is a direct result of assuming:

- The user wants a build system which works. For example, once you told CMaize
  where to install something, CMaize is going to assume it will be installed
  there moving forward, i.e., unlike CMake, CMaize will remember user input
  instead of asking for it each time it is needed.
- The user wants to follow best practices. Thus inputs whose values can be fixed
  by adhering to a best practice, should default to values consistent with those
  best practices.
- The user wants to follow standard conventions. Similar to best practices,
  this assumption again means that CMaize should default to values consistent
  with those conventions.

Note that in the above we do not say that "CMaize forces the user to follow best
practices and/or standard conventions", rather, we use best practices and
standard conventions to choose default values. The user should be free to
override those default values, though the more they deviate from best practices
and/or standard conventions, the less useful CMaize will be.

The point of this page is to collect assumptions that CMaize makes, which CMaize
developers can rely on internally.

*************************
Project-Level Assumptions
*************************

- Each project maps to one package. Users wanting to build
  multiple packages can do so by having the root project build multiple
  sub-projects. The result is that we do not need to ask for the name of
  the project CMaize is currently building, we can simply use
  ``${PROJECT_NAME}`` (note this should not be confused with
  ``${CMAKE_PROJECT_NAME}``, which is the name of the top-most CMake project).
- It is assumed that all source files in a target's source directory are
  associated with that target, i.e., each target (which is not simply a
  different configuration) has its own source directory. Conventionally, this
  is accomplished by having a root source directory which contains source
  directories for each target. The consequence of this assumption is that CMaize
  can automatically find source files given directories and does not need
  itemized lists.

*********************
Packaging Assumptions
*********************

- CMake best practice :cite:`official_import_export` is to namespace imported
  targets with the name of the package. By default, CMaize assumes imported
  targets start with ``${PROJECT_NAME}::``. This applies not only for packages
  CMaize creates, but for packages CMaize finds.
- Versioning of packages CMaize builds follow versioning follow semantic
  versioning :cite:`semantic_versioning`. Packages CMaize
