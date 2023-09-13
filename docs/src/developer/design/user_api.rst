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

.. _designing_cmaizes_user_api:

###########################
Designing CMaize's User API
###########################

:ref:`overview_of_cmaizes_design` called for CMaize to have a functional-style
user :term:`API` written over top of the object-oriented core. This page
describes the design of CMaize's user API.

*******************
What is a User API?
*******************

When a user wants to write a :term:`build system` using CMaize

***********************
User API Considerations
***********************

.. _functional_style_and_cmake_based:

functional-style and cmake-based
   Stemming from design discussions at :ref:`overview_of_cmaizes_design`, it was
   decided that the user-facing API of CMaize needed to be written in
   traditional CMake and should assume functional-style programming.

.. _cmake_to_cmaize:

CMake to CMaize
   Somewhat of a corollary to the :ref:`functional_style_and_cmake_based`
   consideration, user adoption of CMaize is facilitated by having the
   conversion from an existing CMake-based build system to a CMaize-based build
   system be as easy as possible.

   - Generally speaking most CMake :term:`build systems <build system>` follow
     the same flow:

      #. Declare the :term:`project`'s meta data including name, version, etc.
      #. Declare configuration options
      #. Find the dependencies
      #. Setup the :term:`project`'s targets
      #. Install the targets

.. _ua_minimize_redundancy:

minimize redundancy
   One of the motivating considerations for creating CMaize was
   :ref:`minimize_redundancy`. Satisfying this consideration is the job of
   CMaize's user API since ultimately any CMaize-based build system will be
   written using the user API.

.. _ua_package_manager:

package manager
   Building/packaging a dependency/project can be a complicated endeavor. From
   :ref:`overview_of_cmaizes_design`, it has been established that CMaize will
   have :term:`package manager` support. In many cases CMaize serves as a
   unified API for collecting build system data and shuttling it to the package
   manager. It is thus essential that the user API collects all of the data
   necessary to drive the API.

*****************
Proposed User API
*****************

This section introduces a high-level overview of CMaize's user API. The
functions comprising the user API are grouped into categories based on the
steps presented in consideration :ref:`cmake_to_cmaize`. Most of the following
subsections are simply summaries of more detailed design discussions (links to
those design discussions are provided) and do not explicitly touch on all
considerations. This is particularly pertinent in the subsections dealing with
declaring and building dependencies and targets. Here there is a great amount
of complexity hidden under the hood.

Project Setup
=============

Following from the :ref:`functional_style_and_cmake_based` consideration, the
build system the user writes with CMaize should be pure CMake and invoked by
CMake. CMake requires that the first things a build system do are:

   1. Set the minimum version of CMake needed.
   2. Define the :term:`project`.

In turn, the first several lines of a CMaize-based build system will be:

.. code-block:: CMake

   cmake_minimum_required(...)
   project(...)

The next step is to obtain CMaize. This is done through ``FetchContent``.
Since CMaize is not in scope yet obtaining CMaize amounts to
more CMake boilerplate that CMaize can not reduce. The relevant code is:

.. code-block:: CMake

   include(FetchContent)
   FetchContent_Declare(
       cmaize
       GIT_REPOSITORY https://github.com/CMakePP/CMaize
   )
   FetchContent_MakeAvailable(cmaize)
   include(cmaize/cmaize)

Build Options
=============

At this point we have CMaize and the user is encouraged to use CMaize's APIs
as much as possible from this point forward (though we note that since CMaize
relies on traditional CMake targets it is possible to mix and match traditional
CMake and CMaize). The next step in most build systems is to present the user
with a list of configurable options (beyond those intrinsic to CMake itself).
Each option typically has three parts:

#. The variable name storing the option's value.
#. A default value.
#. A description.

Using CMaize the proposed API for declaring build options is:

.. code-block:: CMake

   cmaize_option(enable_feature0 "Feature 0 is used to do something" FALSE)
   cmaize_option(target_platform "What GPU type to target?" NVIDIA)

This API is identical to CMake's
`option <https://cmake.org/cmake/help/latest/command/option.html>`_ command
except that CMaize allows options to have value types other than boolean. This
is useful for avoiding lots of options like `enable_vendor0`, `enable_vendor1`,
etc. (the build system can present a single option ``vendor`` and the user
can specify the vendor with a string).

We also propose the ``cmaize_option_list`` command to minimize needing to type
``cmaize_option``. Using ``cmaize_option_list`` the above snippet would be:

.. code-block:: CMake

   cmaize_option_list(
      enable_feature0 "Feature 0 is used to do something" FALSE
      target_platform "What GPU type to target?" NVIDIA
   )

In practice ``cmaize_option_list`` simply wraps looping over
"name, description, value" triples and feeding them to ``cmaize_option``.

Find Dependencies
=================

Full discussion: :ref:`designing_cmaize_find_or_build_dependency`.

With configuration settings out of the way the next step is to find
dependencies. For dependencies which rely on CMake- (or CMaize-) based build
systems the default package manager will rely on `FetchContent`_ and the
proposed APIs include the more pertinent options to `FetchContent`_:

.. code-block:: CMake

   # For building a dependency if it can not be found
   cmaize_find_or_build_dependency(
      <name>
      URL <where_on_the_internet_to_download_from>
      VERSION <the_version_you_want>
      BUILD_TARGET <target_to_build>
      FIND_TARGET <target_representing_package>
      CMAKE_ARGS <configuration_options_to_set>
   )

   #Or if the build system wants to insist that a dependency must already exist
   cmake_find_dependency(
      <name>
      VERSION <the_version_you_want>
      FIND_TARGET <target_representing_package>
      CMAKE_ARGS <options_it_should_have_been_configured_with>
   )

Generally speaking it must be possible to supply these functions with
whatever information is necessary to find/build the dependency in the target
state. Following from the :ref:`ua_package_manager` consideration, the exact
information needed will be specified by the backend package manager.


Since 3.19 CMake natively supports reading JSON files, could read
dependency information in from a JSON file. Easier to reuse info in CI.

Project Build Targets
=====================

define build targets
   With dependencies found, the user can now start defining the
   :term:`build targets <build target>` of the project. Targets are typically
   things like libraries or executables.

   - Projects may have multiple targets
   - The project's targets should also be built/installed in a manner supported
     by the backend package manager (see consideration

Test Project
============


test project components
   Once all of the targets are defined, the user declares tests which should be
   run on the targets.

   - Tests often require their own dependencies and targets. Dependencies and
     targets pertaining to testing should only be found/built if testing
     is enabled.
   - Again, the package manager should be kept in the loop.

Install Project
===============

If the tests are successful (or were skipped) it's on to :term:`package`
installation. Installation typically requires specifying which targets are
   part of the package, generating the packaging files, and then literally
   moving the targets and files to their final location.

   - Installation should also be done in a manner which considers the
     package manager.

*******
Summary
*******
