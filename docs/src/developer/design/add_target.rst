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

.. _designing_cmaizes_add_target_functions:

#######################################
Designing CMaize's Add Target Functions
#######################################

The discussion on the :ref:`designing_cmaizes_user_api` page motivated the need
for user-facing functions for declaring and adding targets to the build system.

*****************************************
What Are the CMaize Add Target Functions?
*****************************************

CMaize's user-facing :term:`API`` is comprised of functions designed to
integrate easily into CMake-style build systems. CMaize's add target functions
are the pieces of the user :term:`API` through which users can define
:term:`build targets<build target>`, i.e., the libraries, executables, etc.
comprising their :term:`project`. We refer to these functions as the "add
target" functions for generality.

***********************************************
Why Do We Need The CMaize Add Target Functions?
***********************************************

Users need a way to declare :term:`build targets<build target>`. Traditional
CMake provides only two add target functions:

- `add_library <https://cmake.org/cmake/help/latest/command/add_library.html>`_
- `add_executable <https://tinyurl.com/4pxh3cmf>`_

though one should note the `add_library`_ actually covers a number of use
cases, i.e., static libraries, shared libraries, interface libraries, modules,
and object libraries. Modern CMake is target-based and CMaize will ultimately
need to make targets in order to interact with CMake. Thus CMaize's add target
functions will necessarily wrap CMake's add target functions.

The primary reason CMaize needs wrapper functions is to capture the user's
input. More specifically, by recording the user's input to the add target
functions, CMaize will be able to automate packaging of the project. The other
motivation for maintaining a separate set of CMaize add target functions is to
provide more succinct APIs. In practice, declaring CMake targets is very
verbose and much of what needs to be provided can be inferred or learned from
other sources.

**********************************
Add Target Function Considerations
**********************************

recording targets

succinctness

coding language
   Exactly what targets can be built/found depend on the coding language(s) of
   the project.
