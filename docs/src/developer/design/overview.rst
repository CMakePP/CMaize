###########################
Overview of CMaize's Design
###########################

The point of this page is to capture the overall high-level design of

***************
What is CMaize?
***************

CMaize is a CMake module designed to streamline writing build systems for
scientific software. Initial focus is on C++-based projects, but support for
any language CMake supports is straightforward.

**********************
Why do we need CMaize?
**********************

The vast majority of build systems written in CMake are verbose and highly
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
abstractions on top of CMake that will reduce the verbosity and redundancy. This
is where CMaize is needed. CMaize will contain those abstractions.

*********************
CMaize Considerations
*********************

.. _cmake_based_workflow:

cmake-based workflow
   CMake is the de facto build system for C++-based projects. Most consumers who
   intend to compile a C++ based project from source, will have some familiarity
   with CMake and workflows built on CMake (*e.g.*, the standard configure,
   build, test, install CMake commands). CMaize should integrate as seamlessly
   as possible into existing CMake-based workflows.

.. _cmake_based_build_system:

cmake-based build system
   A number of non CMake-based build systems have been proposed for C++.
   Despite many of those build systems being arguably easier to use, CMake still
   remains the de facto choice. Point being, there is a significant amount of
   inertia against adopting non-CMake based build systems by C++ project
   maintainers. Thus the build system the user writes should be pure CMake.

   - By having CMaize be pure CMake, we ensure that tools for CMake continue to
     work for projects using CMaize. Of particular note are most integrated
     development environments.



The next set of considerations, in order, represent the major components of a
user's build system when written with CMaize.

project meta data
   Following from :ref:`cmake_build_system` the build system the user writes
   should be pure CMake. CMake strongly suggests that the first things a user
   does are:

   1. Set the minimum version of CMake needed.

      - This is a call to CMake's
        `cmake_minimum_required https://cmake.org/cmake/help/latest/command/cmake_minimum_required.html`__
        command.

   2. Define the :ref:`term_project`.

      - This is a call to CMake's
        `project <https://cmake.org/cmake/help/latest/command/project.html>`__
        command.

obtain CMaize
   With obligatory CMake boilerplate out of the way, the user is free to start
   using CMaize. Since CMaize is unlikely to be included with CMake
   distributions any time soon, the first step is to obtain CMaize.

   1. `FetchContent_Declare`
   2. `FetchContent_MakeAvailable`
   3. `include(cmaize)`
