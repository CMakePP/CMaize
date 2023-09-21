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

.. _obtaining_cmaize:

****************
Obtaining CMaize
****************

.. _automatically_downloading_and_including_cmaize:

Automatically Downloading and Including CMaize
==============================================

As a convenience to your users you can make it so that your build system
automatically downloads CMaize and includes it. The easiest way to do this is
to put the following CMake script in a file ``cmake/get_cmaize.cmake``:

.. todo: Remove ``include_guard()`` in the ``cmake/get_cmaize.cmake`` example

.. code-block:: cmake

    include_guard()

    #[[
    # This function encapsulates the process of getting CMaize using CMake's
    # FetchContent module. We have encapsulated it in a function so we can set
    # the options for it's configure step without affecting the options for the
    # parent project's configure step (namely we do not want to build CMaize's
    # unit tests).
    #]]
    function(get_cmaize)
        include(FetchContent)
        set(build_testing_old "${BUILD_TESTING}")  # Store the old value
        set(BUILD_TESTING OFF CACHE BOOL "" FORCE)
        FetchContent_Declare(
             cmaize
             GIT_REPOSITORY https://github.com/CMakePP/CMaize
        )
        FetchContent_MakeAvailable(cmaize)
        set(BUILD_TESTING "${build_testing_old}" CACHE BOOL "" FORCE)  # Reset
    endfunction()

    # Call the function we just wrote to get CMaize
    get_cmaize()

    # Include CMaize
    include(cpp/cpp)

and then in your top level ``CMakeLists.txt`` (assumed to be in the same
directory as the ``cmake`` directory you put ``get_cmaize.cmake`` in) add the
line:

.. todo: Add in that the ``include(cmaize)`` call must be after a CMake ``project()`` has been created.

.. code-block:: cmake

   include("${PROJECT_SOURCE_DIR}/cmake/get_cmaize.cmake")

Your project will now download CMaize automatically as part of the CMake
configuration.

.. Download CMaize Manually
.. ========================
..
.. .. TODO go over fetching CMaize repo and setting FETCHCONTENT_SOURCE_DIR_CPP
..
.. Users can use an already downloaded CMaize by setting
.. ``FETCHCONTENT_SOURCE_DIR_CPP`` to the directory of the pre-downloaded CMakePP.
