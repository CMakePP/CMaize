.. _designing_cmaizes_user_api:

###########################
Designing CMaize's User API
###########################

:ref:`overview_of_cmaizes_design` called for CMaize to have a functional-style
user :term:`API` written over top of the object-oriented core. This page
describes the design of CMaize's user API.

TODO: Complete this page. Current content was originally part of overview, but
then I decided to break it off.

***********************
User API Considerations
***********************

.. _functional_style_and_cmake_based:

functional-style and cmake-based
   Stemming from design discussions at :ref:`overview_of_cmaizes_design`, it was
   decided that the user-facing API of CMaize needed to be written in
   traditional CMake and should assume functional-style programming.

Expected Workflow Considerations
================================

The next set of considerations, in order, represent the major steps we expect
a CMaize-based build system to take. Generally speaking these
considerations directly address what CMake should do in each
of the :term:`build phase`\ s. That said CMake will parse the entire
build system during the :ref:`configure_phase`, even the components applying to
later phases.

.. _project_meta_data:

project meta data
   Following from the :ref:`functional_style_and_cmake_based` consideration, the
   build system the user writes with CMaize should be pure CMake and invoked by
   CMake. CMake requires that the first things
   a user do are:

   1. Set the minimum version of CMake needed.

      - This is a call to CMake's
        `cmake_minimum_required <https://tinyurl.com/3w6n75ec>`_
        command.

   2. Define the :term:`project`.

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
   With CMaize obtained (and in scope), users can start writing their build
   system with CMaize, instead of CMake. Typically the first step in writing a
   build system is to define build options needed beyond those defined by CMake
   (*e.g.*, ``CMAKE_BUILD_TYPE``, ``BUILD_TESTING``, and ``BUILD_SHARED_LIBS``).
   Examples include:

   - Enable/disable optional dependencies
   - Enable/disable optional features

.. _find_dependencies:

find dependencies
   With build parameters known we can start looking for dependencies.

   - Finding dependencies can be limited to only searching for already installed
     dependencies, or it can also include having the build system build the
     dependencies if they are not found (as long as we know where we will build
     them, then they are "found").
   - Finding/building dependencies needs to be done in concert with the
     :ref:`package_manager_support` consideration.

.. _define_project_components:

define build targets
   With dependencies found, the user can now start defining the
   :term:`build target`\ s of the project. Targets are typically things like
   libraries or executables.

   - The project's targets should also be built/installed in concert with a
     package manager (see consideration :ref:`package_manager_support`).

.. _test_project_components:

test project components
   Once all of the targets are defined, the user declares tests which should be
   run on the targets.

   - Tests often require their own dependencies and targets. Dependencies and
     targets pertaining to testing should only be found/built if testing
     is enabled.
   - Again, the package manager should be kept in the loop.

.. _install_the_project:

install the project
   If the tests are successful (or were skipped) it's on to :term:`package`
   installation. Installation typically requires specifying which targets are
   part of the package, generating the packaging files, and then literally
   moving the targets and files to their final location.

   - Installation should also be done in a manner which considers the
     package manager.

*******
Summary
*******

:ref:`project_meta_data`
   This consideration primarily impacts CMaize since build system developers
   will have to do it in CMake directly.

:ref:`obtain_cmaize`
   Like :ref:`project_meta_data`, this step primarily impacts CMaize since
   it can not be abstracted away and must be present in the boilerplate.

:ref:`declare_build_options`
   For version 1.0.0 of CMaize we advocate for using CMake's
   `option <https://tinyurl.com/529f5zn7>`_ command. In later versions of
   CMaize we may decide to capture these options in the ``PackageSpecification``

:ref:`find_dependencies`
   This responsibility will ultimately be the responsibility of the ``PackageManager``,
   though we must provide the user a functional API to pass the info to the
   ``PackageManager``. We propose the ``cmaize_find_or_build_dependency``
   commands.

:ref:`define_project_components`
   ``cmaize_add_xxx`` commands have been proposed for these purposes.

:ref:`test_project_components`
   ``cmaize_add_tests`` command has been proposed for this.

:ref:`install_the_project`
    ``cmaize_add_package`` command is responsible for this.
