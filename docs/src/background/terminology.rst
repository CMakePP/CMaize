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

   build target
      This is a generic term for anything built during the
      :term:`build process`. Typical examples of build targets are things
      like libraries, executables, and auto-generated source code. Build targets
      may be combined/consumed to create more build targets.

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

   build system
      The "build system" is the set of :term:`build tools<build tool>` and code
      needed to actually carry out the :term:`build process` for a particular
      :term:`project`. In the context of CMake the build system is comprised
      of ``cmake`` and the project's ``CMakeLists.txt`` files.

   build tool
      A "build tool" is a program designed to facilitate carrying out the
      :term:`build process`. In the context of CMake, examples of build tools
      are ``cmake``, ``ctest``, as well as the build tools ``cmake`` relies on,
      *e.g.*, ``make`` or ``ninja``.

   dependency
      An object, :math:`A`, is a dependency of a :term:`build target`,
      :math:`B`, if :math:`B` can not be built without :math:`A`. :math:`A` is
      typically an already installed :term:`package` or another build target.

   package
      The output of building a :term:`project` is a package. A package
      typically includes a proper subset of the
      :term:`build targets <build target>`
      produced during the :term:`build process` as well as files containing
      metadata about the package. The metadata is usually designed to aid a
      :term:`package manager` in finding the package later.

   package configuration
      The configuration of a :term:`package` refers to the options it was built
      with, e.g., the target architecture, compiler flags (if applicable),
      and enabled features. The configuration also includes the
      :term:`package specification` of each dependency. Note that if a package
      has no dependencies, then the package configuration is simply the build
      options.

   package manager
      Package managers may be part of a :term:`build tool` or they may be
      independent programs. Regardless of their origin, a "package manager" is
      a program or tool which can facilitate finding, building, and tracking of
      :term:`package`. Many times it is the package manager which is
      responsible for determining if a particular package instance can be used
      to satisfy a dependency. Package management is built in to CMake via the
      ``find_package`` command and the ``FetchContent`` module.

   package specification
      A package's specification includes the version of the package and its
      :term:`package configuration`. For a given package, the package's
      specification/configuration is a superset/subset of that package's
      configuration/specification.

   project
      Conceptually a "project" is the input (usually source code) to a
      :term:`build system`. In practice CMake, uses the term project to
      refer to not just the input to the build system, but also the workspace in
      which the :term:`build process` is occurring. In other words, to CMake,
      a project is not just the source code being built, but also the
      :term:`build targets <build target>` produced from the build process.

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

   boilerplate
      Code which is repeated nearly verbatim in multiple source units.

   CLI
      A Command Line Interface (CLI) is a mechanism for a user to interact with
      a program in a traditional terminal environment.

   DAG
      A directed acyclic graph (DAG) is, as the name implies, a mathematical
      graph whose nodes are connected with one-way edges such that there are
      no loops. One of the most common representations for describing control
      flow/dependency is with a DAG. For control flow, nodes represent code
      units and the directions of the edges represent which code unit calls the
      other. For dependencies, nodes represent objects and the directions of the
      edges represent which objects a particular object needs.

   DRY
      Short for "Don't Repeat Yourself", the DRY principle stipulates that it
      is better to introduce an abstraction for getting/setting state than it
      is to rewrite that state. Of particular relevance when discussing CMake,
      copy/pasting runs afoul of DRY because developers may need to change
      multiple build systems if a bug is found, a new best practice is
      introduced, or a new feature is added.

   GUI
      A Graphical User Interface (GUI) is a mechanism for a user to interact
      with a program via a traditional window-based environment.

   HPC
      High-performance computing (HPC) refers to developing and running highly
      optimized software, typically on supercomputers. The key differences,
      compared to traditional software, are the level of optimization and the
      power of the computers the software runs on. Many traditional applications
      involve algorithms of low computational complexity and thus run quickly on
      consumer commodity hardware, with relatively little optimization. HPC
      applications, however, typically involve computational algorithms which
      have computational complexity orders of magnitude more expensive than the
      algorithms found in traditional software. In order for HPC applications
      to obtain answers in a reasonable amount of wall time, the software must
      usually be run on cutting-edge hardware and optimized to obtain so as to
      obtain near peak performance on that hardware.

   KWARGS
      Short for "keyword arguments". The term "kwargs" is widely used in Python
      communities. We've borrowed the term here for referring to how many
      modern CMake functions accept their arguments as key/value pairs.
