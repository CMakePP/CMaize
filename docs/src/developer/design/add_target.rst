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

though it should be noted the `add_library`_ actually covers a number of use
cases, i.e., static libraries, shared libraries, interface libraries, modules,
and object libraries. Modern CMake is target-based and CMaize will ultimately
need to make targets in order to interact with CMake. Thus CMaize's add target
functions will necessarily wrap CMake's add target functions.

The primary reason CMaize needs wrapper functions is to capture the user's
input. More specifically, the CMaize versions of the add target functions will
record the target options in the active ``CMaizeProject`` so that CMaize will
be able to automate packaging of the project. Another motivation for
maintaining a separate set of CMaize add target functions is to
provide more succinct APIs. In practice, declaring CMake targets can be very
verbose and much of what needs to be provided can be inferred or learned from
other sources.

**********************
Add Target Terminology
**********************

CMaize will be dealing with targets associated with multiple coding languages.
Generally speaking most of these coding languages have terms to describe
similar concepts; however, they disagree on what those terms are. In order to
provide a unified description we define the following terms and will use these
terms throughout this page regardless of what the coding-language appropriate
terms are.

.. glossary::

   executable
      A program meant to be run by a user. It may be compiled or it may not be,
      e.g., a Python script with a ``main`` function.

   library
      A collection of functionality distributed as a single packaged entity.

   source file
      A file containing code. For languages like C++, "source file" includes
      header files.

As a slight aside, we choose these terms in order to conform to CMake's already
existing :term:`API`.

**********************************
Add Target Function Considerations
**********************************

recording targets
   The primary motivation for the add target functions is to serve as a
   mechanism for recording the details of the target.

succinctness
   A lot of the information CMake's add target functions require can be gleamed
   from other sources. Requiring the user to restate the information is
   verbose and violates :term:`DRY`.

coding language
   Exactly what targets can be built/found depend on the coding language(s) of
   the project. For example, shared/static :term:`libraries <library>` do not
   exist in the context of building a Python code, but do exist when building
   C/C++ code.

   - Targeted coding languages include: C, C++, CMake, Fortran, Python, and
     extensions of the aforementioned languages (e.g., CUDA and OpenMP).

target sources
   Targets are usually associated with :term:`source files<source file>`.

   - As a corollary we note that source files usually fall into two categories,
     public and private. With public needing to be redistributed with the
     target and private being consumed in building the target.

conditional targets
   Many projects contain targets which are only conditionally built. These
   targets may be optional package features, or targets only needed for testing
   or maintaining the project. In our experience, in a traditional CMake-based
   :term:`build system`, it is rarely possible to isolate the logic for these
   targets because CMake requires them to be specified in multiple places. We
   assume the following about a conditional target:

   - is conditionally included based on the value of a variable (if it's
     actually multiple variables, the user, via boolean logic, can combine the
     variables into a single variable). For optional features the variable is
     usually something like ``ENABLE_XXX``; for tests the variable is
     ``BUILD_TESTING`` (defined by CMake).
   - needs to be conditionally built, linked to, tested, and packaged. In other
     words, when CMaize is given a list of targets, CMaize needs to skip
     conditional targets which are not currently enabled.
