.. _description-label:

Project Description
===================

CMake is quickly becoming the *de facto* framework for implementing build
systems for C and C++ projects (FORTRAN adoption is also increasing).  Like its
chief competitor, GNU's Autotools, CMake suffers from complexity.  In our
opinion, much of the complexity of CMake comes from handling of a package's
dependencies.  Since there is no uniform packaging mechanism for C/C++, CMake
necessarily must provide very flexible interfaces for locating and consuming
dependencies.  This flexibility comes at the cost of additional complexity and
makes writing a reliable build system a time-consuming endeavor. CMake
Packaging Project (CPP) is designed to simplify this procedure.

At its heart CPP is a dependency manager written entirely within CMake.  This
means CPP knows how to:
* locate a dependency,
* assess the suitability of a found dependency, and
* in the event a suitable version can not be located, create one,
all without introducing additional dependencies into your project.  In practice
usage of a dependency manager reduces the remaining CMake infrastructure to
boilerplate, therefore CPP also includes CMake extensions for wrapping this
boilerplate.  The result is that writing a new CMake-based build system for a
project is as easy as:

.. code-block:: cmake

   cmake_minimum_required(VERSION <minimum_version>)
   project(<project_name> VERSION <project_version>)
   find_package(cpp REQUIRED)
   foreach(depend <depend1> <depend2> ...)
       cpp_find_dependency(${depend})
   endforeach()
   cpp_add_library(
       <library_name>
       SOURCES <list_of_sources>
       INCLUDES <list_of_headers>
       DEPENDS <list_of_dependencies>
   )
   cpp_install(TARGETS <library_name>)

This example is the base boilerplate for a typical project.  The project is
responsible for filling in the quantities in angle brackets.

Features
--------

The following is a list of CPP's key features.  Features are broken into
three categories:

* Dependency Support
    Features designed around facilitating the inclusion of dependencies.
* Project Support
    Features designed to simplify the specification and packaging of your
    project.
* Other
    Miscellaneous features I may categorize at a later point

.. todo::
   Link features to the respective documentation

Dependency Support
++++++++++++++++++

* Dependencies with source explicitly included in the project (v1.0.0)
* Dependencies hosted on public and private GitHub-based repositories (v1.0.0)
* Virtual dependencies (*e.g.*, MPI and BLAS) supported (v1.0.0)
* Multiple recipe repositories (v1.0.0)
* Dependencies can be versioned by commit, branch, or version (v1.0.0)

Project Support
+++++++++++++++

* shared and static libraries (v1.0.0)
* executables (v1.0.0)
* multiple project components (v1.0.0)

Other
+++++

* Unit testing framework fo CMake functions (v1.0.0)
