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

.. _overview:

########
Overview
########

CMaize greatly simplifies the process of creating a build system for projects
by allowing users to create a single ``CMakeLists.txt`` file at the root of
their project. This file handles the finding and building of the projects
**executables**, **libraries**, **tests**, as well as any **dependencies**
of the project. Many projects can be built using only the commands provided in
CMaize's user API. Here is a brief overview of the features CMaize provides:

==============
Add Executable
==============

The ``cpp_add_executable`` command allows you to add an executable by providing
the executable's source directories, include directories, and dependencies:

.. code-block:: cmake

    cpp_add_executable(
        your_executable_name
        SOURCE_DIR /path/to/your/executable/source/dir
        INCLUDE_DIR /path/to/your/executable/include/dir
        DEPENDS dependency1 dependency2
    )

This command will add an executable to the project using the specified source
and include directories and find or build all of the executable's dependencies.

===========
Add Library
===========

The ``cpp_add_library`` command allows you to add a library by providing the
library's source and include directories and all of the library's dependencies:

.. code-block:: cmake

   cpp_add_library(
       your_library_name
       SOURCE_DIR /path/to/your/library/source/dir
       INCLUDE_DIR /path/to/your/library/include/dir
       DEPENDS dependency1 dependency2
   )

The above snippet will automatically find your library's header and source
files, create and configure a CMake build target for your library, generate the
packaging files for your library, configure an install target, and
and find or build all of the library's dependencies.

========
Add Test
========

The ``cpp_add_tests`` command allows you to add tests to your project by
providing the source directory for the tests and the tests' dependencies:

.. code-block:: cmake

    cpp_add_tests(
        your_tests_name
        SOURCE_DIR "path/to/your/tests/directory"
        DEPENDS dependency1 dependency2
    )

This command will add all the tests that it finds in the source directory,
find or build the dependencies, and create an executable that runs the tests.

========================
Find or Build Dependency
========================

The real power of CMaize is that it makes it easy to integrate dependencies into
your project's build system. For example, if one of your project's libraries
depends on a dependency `name_of_dependency` you can use the
``cpp_find_or_build_dependency`` command to find the dependency:

.. code-block:: cmake

    cpp_find_or_build_dependency(
        name_of_dependency
        URL github.com/an_organization/the_dependency
        BUILD_TARGET the_dependency
        FIND_TARGET  the_dependency::the_dependency
    )

This relatively small snippet will properly look for the dependency using
CMake's `find_package` command. If the dependency is not found, CMaize will
then build it using CMake's `FetchContent` module.
