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

#############################
Terminology and Abbreviations
#############################

The point of this page is to define the terminology and abbreviations used
through CMaize and its documentation. Terms/abbreviations are grouped into
categories and then listed alphabetically.

.. note::

   Maintainers of CMaize's documentation are encouraged to stick to these
   terms/abbreviations. All terms/abbreviations should be linked back to
   minimally on their first usage on a page.

*****************
CMake Terminology
*****************

As a disclaimer we decided to not distinguish between CMake-specific terminology
and terminology which applies to other build systems as well.

.. glossary::

   build targets
   build target
      This is a generic term for anything built during the
      :term:`build process`. Typical examples of build targets are things
      like libraries, executables, and auto-generated source code. Build targets
      may be combined/consumed to create more build targets.

   build phases
   build phase
      The :term:`build process` is typically decomposed into several steps.
      Each step is referred to as a "build phase". See :ref:`build_phases` for
      details on the typical CMake build phases.

   build process
      Historically the "build process" (often abbreviated as "the build") was
      the process of building binary files from source code. In modern parlance
      it is now the more general process of going from some initial source
      distribution (say a tar ball, zip archive, or a git repository) to the
      finished, working software product you actually want. Compiling may or may
      not be involved.

   build systems
   build system
      The "build system" is the set of :term:`build tools` and code needed to
      actually carry out the :term:`build process` for a particular
      :term:`project`. In the context of CMake the build system is comprised
      of ``cmake`` and the project's ``CMakeLists.txt`` files.

   build tools
   build tool
      A "build tool" is a program designed to facilitate carrying out the
      :term:`build process`. In the context of CMake, examples of build tools
      are ``cmake``, ``ctest``, as well as the build tools ``cmake`` relies on,
      *e.g.*, ``make`` or ``ninja``.

   dependency
      An object, :math:`A`, is a dependency of a :term:`build target`,
      :math:`B`, if :math:`B` can not be built without :math:`A`. :math:`A` is
      typically an already installed :term:`package` or another build target.

   packages
   package
      The output of building a :term:`project` is a package. A package
      typically includes a proper subset of the :term:`build targets`
      produced during the :term:`build process` as well as files containing
      metadata about the package. The metadata is usually designed to aid a
      :term:`package manager` in finding the package later.

   package manager
      Package managers may be part of a :term:`build tool` or they may be
      independent programs. Regardless of their origin, a "package manager" is
      a program or tool which can facilitate finding, building, and tracking of
      :term:`package`. Many times it is the package manager which is
      responsible for determining if a particular package instance can be used
      to satisfy a dependency. Package management is built in to CMake via the
      ``find_package`` command and the ``FetchContent`` module.

   projects
   project
      Conceptually a "project" is the input (usually source code) to a
      :term:`build system`. In practice CMake, uses the term project to
      refer to not just the input to the build system, but also the workspace in
      which the :term:`build process` is occurring. In other words, to CMake,
      a project is not just the source code being built, but also the
      :term:`build targets` produced from the build process.

****************************
Computer Science Terminology
****************************

.. glossary::

   API
      The application programming interface (API) of a software component is the
      set of interfaces it exposes which enable the software component to be
      called by other software components.
      In practice, a component's API usually amounts to one or more coding
      language bindings that allow the component to be manipulated directly from
      the source code of another software component.
