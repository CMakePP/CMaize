*******************************************
Example Project using CMake Style Structure
*******************************************

This chapter provides an overview of a project structured in a style that
is common to CMake projects that uses CMaize as its build system.

Project Overview
================

``MyCMakeProject`` is a simple C++ project that consists of the following
components:

* The ``TravelCostUtils`` library that contains some simple arithmetic
  calculations for use in calculating travel costs.

* The ``TravelCostCalc`` executable that calculates travel cost for a set of
  predefined values using functions in ``TravelCostUtils``.

* The ``Test`` directory contains some tests written using the Catch2 library
  that test that ``TravelCostUtils`` works properly.

Here is the file structure of the project:

::

    MyCMakeProject
    ├── CMakeLists.txt
    ├── cmake
    │   └── get_cpp.cmake
    ├── TravelCostUtils
    |   ├── TravelCostUtils.cpp
    |   └── TravelCostUtils.hpp
    ├── TravelCostCalc
    |   └── TravelCostCalc.cpp
    └── Test
        └── test.cpp

This structure is commonly found in CMake projects. A subdirectory is created
for each executable and library. A subdirectory is also created the project's
tests.

Creating the CMakeLists.txt File
================================

Here we will cover the contents of the ``CMakeLists.txt`` file at the root of
the project.

The Basics
^^^^^^^^^^

First we must start with the basics. We need to declare the minimum required
version of CMake, the name and version of the project, and the C++ standard
of the project.

.. code-block:: cmake

    # Declare minimum version required
    cmake_minimum_required(VERSION 3.13.4)

    # Declare project name and version
    project(MyCMakeProject VERSION 1.0)

    # Set C++ standard
    set(CMAKE_CXX_STANDARD 14)

Including CMaize
^^^^^^^^^^^^^^^^

We also need to include CMaize. This is described more in
:ref:`Automatically Downloading and Including CMaize`.

.. code-block:: cmake

    # Include CMaize automatically
    include("${PROJECT_SOURCE_DIR}/cmake/get_cpp.cmake")

Adding the TravelCostUtils Library
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Now we will add our ``TravelCostUtils`` library. We need to specify the target
name, its source directory, and its include directory:

.. code-block:: cmake

    # Add our TravelCostUtils library
    cpp_add_library(
        TravelCostUtils
        SOURCE_DIR "${CMAKE_CURRENT_LIST_DIR}/TravelCostUtils"
        INCLUDE_DIR "${CMAKE_CURRENT_LIST_DIR}/TravelCostUtils"
    )

Adding the TravelCostCalc Executable
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Here we add our ``TravelCostCalc`` executable. We simply need to specify
the target name, its source directory, and its dependencies:

.. code-block:: cmake

    # Add the executable
    cpp_add_executable(
        TravelCostCalc
        SOURCE_DIR "${CMAKE_CURRENT_LIST_DIR}/TravelCostCalc"
        DEPENDS TravelCostUtils
    )

Getting the Catch2 Unit Test Framework
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Now we will find and build the Catch2 unit testing framework. We need to do the
following:

#. Create a target name for it (``Catch2`` in this case)
#. Point to its GitHub repository URL using the ``URL`` keyword
#. Specify the target we want to build in the repository using the
   ``BUILD_TARGET`` keyword
#. Specify the target name we want to use to find this library using the
   ``FIND_TARGET`` keyword
#. Additionally we will pass in the ``BUILD_TESTING=OFF`` argument so that no
   tests are built for the library. Passing in arguments is accomplished by
   using the ``CMAKE_ARGS`` keyword.

.. code-block:: cmake

    # Get the Catch2 unit testing framework
    cpp_find_or_build_dependency(
        Catch2
        URL github.com/catchorg/Catch2
        BUILD_TARGET Catch2
        FIND_TARGET Catch2::Catch2
        CMAKE_ARGS BUILD_TESTING=OFF
    )

Adding Tests
^^^^^^^^^^^^

Now we can add our tests. We just need to specify the source directory and the
tests dependencies (which in this case are our ``TravelCostUtils`` library and
the ``Catch2`` testing framework).

.. code-block:: cmake

    # Add the tests
    cpp_add_tests(
        TravelCostUtilsTest
        SOURCE_DIR "${CMAKE_CURRENT_LIST_DIR}/test"
        DEPENDS TravelCostUtils Catch2::Catch2
    )

.. note::

    Here we are using ``Catch2::Catch2`` to find the Catch2 library. This is
    what we specified as the ``FIND_TARGET`` when finding and building Catch2.

Final Project
=============

This final example project can be downloaded
:download:`here <./MyCMakeProject.zip>`.

Building the Project
====================

The project can be built by running the following commands at the root of the
project:

.. code-block:: bash

    # Create the build system
    cmake -B build

    # Build the project
    cmake --build build
