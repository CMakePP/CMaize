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

*****************************************
Example Project using GNU Style Structure
*****************************************

This chapter provides an overview of a project using the GNU style structure
that uses CMaize as its build system.

Project Overview
================

``ExampleGNUProject`` is a simple C++ project that consists of the following
components:

* The ``travel_cost_utils`` library that contains some simple arithmetic
  calculations for use in calculating travel costs.

* The ``travel_cost_calc`` executable that calculates travel cost for a set of
  predefined values using functions in ``travel_cost_utils``.

* The ``test`` directory that contains some tests written using the Catch2
  library that test that ``travel_cost_utils`` works properly.

Here is the directory structure of the project:

::

    ExampleGNUProject
    ├── CMakeLists.txt
    ├── cmake
    │   └── get_cmaize.cmake
    ├── include
    |   └── example_gnu_project
    |       └── travel_cost_utils
    |           └── travel_cost_utils.hpp
    ├── src
    │   ├── travel_cost_utils
    |   |   └── travel_cost_utils.cpp
    │   └── travel_cost_calc
    │       └── travel_cost_calc.cpp
    └── test
        └── travel_cost_utils
            └── test_travel_cost_utils.cpp

This structure breaks the project down in the following way:

* ``include/example_gnu_project`` contains the public headers for the projects
  libraries, separated into directories for each library.

* ``src`` contains the source code for the project, separated into
  subdirectories for each executable and library.

* ``test`` contains the tests for the project, broken down into subdirectories

The advantage to using this type of structure over the CMake style structure
is that this structure explicitly separates public and private header files.
The CMake style structure requires the user to handle the public/private-ness
of header files.

Creating the CMakeLists.txt File
================================

Here we will cover the contents of the ``CMakeLists.txt`` file at the root of
the project.

The Basics
^^^^^^^^^^

First we must start with the basics. We need to declare the minimum required
version of CMake, the name and version of the project, the language of the
project, and the C++ standard of the project.

.. code-block:: cmake

    # Declare minimum version required
    cmake_minimum_required(VERSION 3.13.4)

    # Declare project name and version
    project(example_gnu_project VERSION 1.0)

    # Set the project language
    set(LANGUAGE CXX)

    # Set C++ standard
    set(CMAKE_CXX_STANDARD 14)


Including CMaize
^^^^^^^^^^^^^^^^

We also need to include CMaize. This is described more in
:ref:`automatically_downloading_and_including_cmaize`.

.. code-block:: cmake

    # Include CMaize automatically
    include("${PROJECT_SOURCE_DIR}/cmake/get_cmaize.cmake")

Adding the TravelCostUtils Library
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Now we will add our ``travel_cost_utils`` library. We need to specify the target
name, its source directory, and its include directory:

.. code-block:: cmake

    # Add our travel_cost_utils library
    cpp_add_library(
        travel_cost_utils
        SOURCE_DIR "${CMAKE_CURRENT_LIST_DIR}/src/travel_cost_utils"
        INCLUDE_DIR "${CMAKE_CURRENT_LIST_DIR}/include/example_gnu_project/travel_cost_utils"
    )

Adding the TravelCostCalc Executable
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Here we add our ``travel_cost_calc`` executable. We simply need to specify
the target name, its source directory, and its dependencies:

.. code-block:: cmake

    # Add the travel_cost_calc executable
    cpp_add_executable(
        travel_cost_calc
        SOURCE_DIR "${CMAKE_CURRENT_LIST_DIR}/src/travel_cost_calc"
        DEPENDS travel_cost_utils
    )

Adding Tests
^^^^^^^^^^^^

Now we will add our tests. First, we'll create an ``if`` block so that our tests
are only built if the ``BUILD_TESTING`` argument is set to ``ON`` (or some other
"truthy" value):

.. code-block:: cmake

    if("${BUILD_TESTING}")

        # Stuff for building tests will go here

    endif()

Next we will add a target for finding or building the Catch2 unit testing
framework. We need to do the following:

#. Create a target name for it (``Catch2`` in this case)
#. Point to its GitHub repository URL using the ``URL`` keyword
#. Specify the target we want to build in the repository using the
   ``BUILD_TARGET`` keyword
#. Specify the name we want to use to find this library using the
   ``FIND_TARGET`` keyword
#. Additionally we will pass in the ``BUILD_TESTING=OFF`` argument so that no
   tests are built for the library. Passing in arguments is accomplished by
   using the ``CMAKE_ARGS`` keyword.

.. code-block:: cmake

    if("${BUILD_TESTING}")

        # Get the Catch2 unit testing framework
        cpp_find_or_build_dependency(
            Catch2
            URL github.com/catchorg/Catch2
            BUILD_TARGET Catch2
            FIND_TARGET Catch2::Catch2
            CMAKE_ARGS BUILD_TESTING=OFF
        )

    endif()

Finally, to add our tests, we just need to specify the source directory and the
tests dependencies (which in this case are our ``TravelCostUtils`` library and
the ``Catch2`` testing framework). We will put our tests and their dependencies
within an ``if`` block so that they are only built if users set the
``BUILD_TESTING`` argument to ``ON`` (or some other "truthy" value).

.. code-block:: cmake

    # Build tests if build testing is enabled
    if("${BUILD_TESTING}")

        # Get the Catch2 unit testing framework
        cpp_find_or_build_dependency(
            Catch2
            URL github.com/catchorg/Catch2
            BUILD_TARGET Catch2
            FIND_TARGET Catch2::Catch2
            CMAKE_ARGS BUILD_TESTING=OFF
        )

        # Add the tests
        cpp_add_tests(
            travel_cost_utils_test
            SOURCE_DIR "${CMAKE_CURRENT_LIST_DIR}/test"
            DEPENDS travel_cost_utils Catch2::Catch2
        )

    endif()

.. note::

    Here we use Catch2::Catch2 to find the Catch2 test framework as this is
    the name of the target exported by Catch2.

Building the Project
====================

The project can be built by running the following commands at the root of the
project:

.. code-block:: bash

    # Create the build system
    cmake -B build

    # Build the project
    cmake --build build

Running the Executable and Tests
================================

We can run our executable and our tests with the following commands:

.. code-block:: bash

    # Run the executable
    ./build/travel_cost_calc

    # Run the tests
    ./build/travel_cost_utils_test

Final Project Code
==================

This final example project can be viewed and downloaded
`here <https://github.com/CMaizeExamples/ExampleGNUProject>`_.
