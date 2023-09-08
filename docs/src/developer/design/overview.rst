..
   Copyright 2023 CMakePP

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.

###########################
Overview of CMaize's Design
###########################

The point of this page is to capture the overall high-level design of the
CMaize project.

***************
What is CMaize?
***************

CMaize is a CMake module designed to streamline writing
:ref:`term_build_system`\ s for scientific software. Initial focus is on
C++-based :ref:`term_project`\ s, but support for any language CMake supports
is straightforward.

**********************
Why do we need CMaize?
**********************

For full discussion see :ref:`statement_of_need`.

The vast majority of build systems written for CMake are verbose and highly
redundant. Generally speaking, it seems that the broader CMake community has
accepted that this "is simply the way CMake build systems are" and has stopped
trying to improve them. Evidence for this claim comes from tutorials prominently
showcasing boilerplate code, the growing reliance on template repositories, and
the tried and true technique of copy/paste-ing CMake scripts from one project
into another. All of these approaches run afoul of the
`"Don't Repeat Yourself (DRY)" <https://tinyurl.com/28x7h46c>`__ paradigm and
subsequently suffer from the same problems proponents of DRY seek
to avoid, *e.g.*, multiple sources of truth, lack of synchronization,
and coupling the logic of distinct units of code.

Given that CMake is a full-featured coding language, it is possible to write
abstractions as CMake extensions which will reduce the verbosity and redundancy,
but this is not often done. We speculate that the primary hurdle to developing
such abstractions is lack of support. Most support for scientific software is
aimed at method development and not at software maintenance/sustainability. As
a result build systems are low priority. This is why CMaize is needed. CMaize
will be a reusable, :ref:`term_build_tool` built on top of CMake designed to
streamline writing build systems, particularly build systems of scientific
software.

*********************
CMaize Considerations
*********************

.. _cmake_based_build_system:

cmake-based build system
   A number of non CMake-based build systems have been proposed for C++.
   Despite many of those build systems being arguably easier to use, CMake still
   remains the de facto choice. Point being, there is a significant amount of
   inertia against adopting non-CMake based build systems by C++ project
   maintainers. Thus the build system the user writes should rely on the
   CMake scripting language.

   - By having CMaize be written purely in CMake, we ensure that tooling built
     for CMake continues to work for projects which use CMaize as well. Of
     particular note are most integrated development environments.

.. _cmake_based_workflows:

cmake-based workflows
   CMake is the de facto build tool for C++-based projects. Most consumers who
   intend to compile a C++ based project from source, will have some familiarity
   with CMake's :ref:`term_build_phase`\ s and the corresponding CMake commands.
   We want CMaize to integrate as seamlessly as possible into existing CMake-
   based workflows. Ideally consumers building projects with CMaize build
   systems won't even know it!

.. _object_oriented:

object-oriented
   Current computer science wisdom holds that abstractions are conceptually
   easier to implement using object-oriented programming.

   - CMake is a functional language, thus :ref:`cmake_based_build_system` means
     that if CMaize adopts object-oriented paradigms it needs to be done "under
     the hood" to be :ref:`term_api` compatible with CMake.
   - CMaize developers can "avoid" having to write an object-oriented extension
     to CMake by using the
     `CMakePP Language <https://github.com/CMakePP/CMakePPLang>`_
     (quotes on avoid because the CMakePP Language is developed and maintained
     by the same organization as CMaize...).

.. _package_manager_support:

package manager support
   CMake has integrated :ref:`term_package_manager` support; however, CMake's
   package manager support does not always play nicely with widely used package
   managers, particularly those designed for non-C++ languages (*e.g.*,
   ``pip``). In practice, modern scientific C++ projects increasingly want to
   interact with external package managers, either because they want to be
   buildable via those package managers and/or because they want to use those
   package managers to build dependencies.

   - Note that because of :ref:`cmake_based_build_system` it is unlikely that
     C++ developers will migrate to alternative build systems and CMaize is
     thus faced with integrating package manager support into CMake.
   - A lot of the redundancy build system maintainers face comes from
     finding, building, and installing packages (including the package
     the project results in).

Expected Workflow Considerations
================================

The next set of considerations, in order, represent the major components of a
user's build system when written with CMaize. Generally speaking these
considerations directly address what CMake should do in each
of the :ref:`term_build_phase`\ s. That said CMake will parse the entire
build system during the :ref:`configure_phase`, even the components applying to
later phases.

.. _project_meta_data:

project meta data
   Following from :ref:`cmake_based_build_system` the build system the user
   writes with CMaize should be pure CMake. CMake strongly suggests that the
   first things a user do are:

   1. Set the minimum version of CMake needed.

      - This is a call to CMake's
        `cmake_minimum_required <https://tinyurl.com/3w6n75ec>`_
        command.

   2. Define the :ref:`term_project`.

      - This is a call to CMake's
        `project <https://cmake.org/cmake/help/latest/command/project.html>`__
        command.

.. _obtain_cmaize:

obtain CMaize
   With obligatory CMake boilerplate out of the way, the user is free to start
   using CMaize. Since CMaize is unlikely to be included with CMake
   distributions any time soon, the first step is to obtain CMaize. The current
   best practice for obtaining CMake modules is through
   `FetchContent <https://tinyurl.com/yubmtj8m>`_, *i.e.*:

   1. `FetchContent_Declare <https://tinyurl.com/yzxm6y2d>`_
   2. `FetchContent_MakeAvailable <https://tinyurl.com/mtteytj7>`_
   3. `include(cmaize) <https://tinyurl.com/p2r8xut2>`__

.. _declare_build_options:

declare build options
   In addition to build options defined by CMake (*e.g.*, ``CMAKE_BUILD_TYPE``,
   ``BUILD_TESTING``, and ``BUILD_SHARED_LIBS``), most projects have additional
   options affecting the exact details of the build. Examples include:

   - Enable/disable optional dependencies
   - Enable/disable optional features

.. _find_dependencies:

find dependencies
   With build parameters known and CMaize obtained (and in scope) users can now
   start writing their build system using CMaize. To that end, the first thing
   most builds do is find the needed dependencies.

   - Finding dependencies can be limited to only searching for already installed
     dependencies or it can also include building the dependencies if they are
     not found (as long as we know where we built them, they are "found").

.. _define_project_components:

define project components
   With dependencies in tow we can now start defining the components of the
   project. Here "components" refers to pieces of the overall project. Exactly
   what the components are depends on the project, but they are typically
   things like libraries or executables.

.. _test_project_components:

test project components
   Once all of the components are defined, the user typically then declares
   tests which should be run on the components.

   - Tests often require their own dependencies and components. Testing
     dependencies and components are only respectively found/built if testing
     is enabled.

.. _install_the_project:

install the project
   If the tests are successful (or were skipped) its on to package installation.
   Installation typically requires specifying which components are part of the
   package.

************
Proposed API
************

At this point in the design discussion what arguably matters most is what the
CMaize user sees. Subsequent design discussions can focus on how the API is
implemented.

*******
Summary
*******

:ref:`cmake_based_build_system`
   CMaize is written entirely in CMake and its required dependencies are also
   written entirely in CMake.

:ref:`cmake_based_workflows`
   Consumers interact with ``CMakeLists.txt`` written with CMaize no differently
   than they would with ``CMakeLists.txt`` written with CMake alone. Therefore,
   CMaize-based build systems seamlessly integrate into existing workflows.

:ref:`object_oriented`
   CMaize has adopted the `CMakePP Language`_ under the hood.

:ref:`package_manager_support`
   All APIs dealing with build targets allow the user to provide a package
   manager.

:ref:`project_meta_data`
   This consideration primarily impacts CMaize in that build system developers
   will have to do it in CMake directly.

:ref:`obtain_cmaize`
   Like :ref:`project_meta_data`, this step primarily impacts CMaize in that
   it can not be abstracted away and must be present in the boilerplate.

:ref:`declare_build_options`
   For version 1.0.0 of CMaize we advocate for using CMake's
   `option <https://tinyurl.com/529f5zn7>`_ command. In later versions of
   CMaize we may decide to capture these options in the ``PackageSpecification``

:ref:`find_dependencies`
   This responsibility will ultimately be punted to the ``PackageManager``,
   though we must provide the user a functional API to pass the info to the
   ``PackageManager``. We propose the ``cmaize_find_or_build_dependency``
   commands.

:ref:`define_project_components`
   ``cmaize_add_xxx`` commands have been proposed for these purposes.

:ref:`test_project_components`
   ``cmaize_add_tests`` command has been proposed for this.

:ref:`install_the_project`
    ``cmaize_add_package`` command is responsible for this.
