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

.. _cmakes_package_manager:

#######################
CMake's Package Manager
#######################

.. note::

   CMake is constantly adding new features. In recent releases, many of the
   new features are targeted at topics considered on this page. The information
   on this page was accurate circa CMake 3.11 (which was released in 2018 at
   about the time we started floating ideas about what would become CMaize).


:term:`Build systems <build system>` and
:term:`package managers<package manager>` often work together to build a
:term:`project`. For better or for worse, many build systems relying on
traditional CMake attempt to be both the build system and the package manager.
Making matters worse, most build systems assume that CMake is driving the
build, not a package manager. What this means is that if a build system
designer wants to enable package manager support, while still having their
package be build-able by CMake, the package manager must be integrated into
CMake.

CMaize was designed from the onset to support package managers under a
CMake-based :term:`API`. Key to this effort is establishing a package manager
component (see :ref:`designing_cmaizes_packagemanager_component`).
By default the package manager component uses what we call CMake's built-in
package manager. Admittedly, CMake is not usually discussed in this
manner and the purpose of this page is to explain how CMaize maps CMake's
existing functions to a package manager.

.. _cpm_package_manager_responsibilities:

********************************
Package Manager Responsibilities
********************************

Before discussing how CMake is mapped to a package manager, we briefly review
the responsibilities of a package manager.

The primary responsibility of a package manager is, as the name states, to
maintain a set of :term:`packages <package>`. When a user wants to use a
package they need only request it from the the package manager and the package
manager does the rest. The package manager's job is very easy if the user's
request is very simple (e.g., "any version of Python"), and the package is
already available. The usefulness of a package manager can be measured by how
well it is able to handle complicated requests (e.g., Python version 3.12.0,
compiled with GCC version 9.5, ``-O2``, ...) and obtain packages which are not
already installed. Ideally this process will be as efficient as possible, e.g.,
the package manager should avoid re-compiling already existing package
dependencies, if they satisfy the package specification.

In satisfying their primary responsibility, package managers must be able to:

.. _pmr_package_specs:

Understand :term:`package specifications <package specification>`.
   Notably this includes knowing what other packages the package depends on.

.. _pmr_inspect_packages:

Inspect managed packages.
   This can include not only the package's specification, but also the
   integrity of the package (does it work?) and its authenticity (is it really
   what it says it is?).

.. _pmr_compare_packages:

Compare and discern among managed packages.
   In particular the package manager must be able to not only realize when two
   packages are entirely different (e.g., one is say a C++ compiler and the
   other is a Python interpreter), but also be able to discern among different
   specifications of the same package.

   - Comparisons are usually needed to know if a package could be used to
     satisfy a particular package specification.

.. _pmr_obtain_new_packages:

Obtain new packages.
   New packages can come from manual addition (a non-ideal solution),
   downloading, or even other package managers.

.. _pmr_facilitate_use_of_managed_packages:

Facilitate use of managed packages.
   If a package manager possesses a package, but the user can not use the
   package, the package is of no use. The package manager must provide
   mechanisms so that the package can actually be used.

   - This is particularly relevant for packages which were added to the package
     manager as dependencies of other packages. Often these packages are not
     located in places which are readily accessible to the user.

Many package managers also have a number of other features including removing
and updating packages. These features are not part of the above list because,
from the perspective of a build system, these features are not strictly
necessary.

**************************
CMake as a Package Manager
**************************

.. note::

   This section describes CMake pre version 3.24. Version 3.24 introduces
   dependency providers which invalidates some of this discussion.

The extent of CMake's package management functions largely boils down to
``find_package`` and the ``FetchContent`` module (for modern CMake; older CMake
build systems often relied on the ``ExternalProject`` module instead of
``FetchContent``). CMake's native ability to understand package specifications
is largely limited to the package's name, the version number, and a list of
components. For everything else, CMake defers to the package developer.

Inspecting packages happens under ``find_package`` via one of two mechanisms.
The best practices mechanism is for packages to provide a config file (allowed
names are ``PackageNameConfig.cmake`` or ``package_name-config.cmake``) and a
version file (``PackageNameConfigVersion.cmake`` or
``package_name-config-version.cmake``). Alternatively, a find module may be
provided (``FindXXX.cmake`` where ``XXX`` is the name passed to
``find_package``). Regardless of which mechanism is used, it is the ``.cmake``
files' responsibility to make sure CMake has the package specification
information it needs (the version and available components; the package name is
used to locate the files). CMake considers the packages a match if the version
information and components provided by the files match what the user asked for.
To enforce checks on other parts of the package specification, the config file
author can ensure that ``XXX_FOUND`` (``XXX`` again being the name provided to
``find_package``) is set to false if the package associated with the files does
not satisfy the additional specifications. It is also the responsibility of
these files to provide the caller of ``find_package`` with a target representing
the dependency.

Obtaining new packages is done via the functions in CMake's ``FetchContent``
module. However, the ``FetchContent`` module really only targets packages which
can be used upon downloading, or packages which can be configured and built
with CMake. Since ``FetchContent`` takes the union of all packages' build
systems, it is worth noting that not all packages which use CMake are
``FetchContent`` compatible; in particular, packages which define targets with
the same name, overwrite global variables, or do not strictly follow the usual
CMake :term:`build process` are NOT compatible with ``FetchContent``.

Summarily, with respect to the list in
:ref:`cpm_package_manager_responsibilities`:

:ref:`pmr_package_specs`
   CMake natively understands versions and components. Package maintainers need
   to register their package's version and components with CMake in order to use
   CMake's native support. Any additional package specification content must be
   manually checked.

:ref:`pmr_inspect_packages`
   Inspecting packages is done under the hood of the ``find_package`` function.
   More specifically ``find_package`` loops over a set of paths and looks for
   config files. If a config file matching the project's name is found it then
   reads in the package specification.

:ref:`pmr_compare_packages`
   Once CMake has read in a config file it will compare the package
   specifications (version and components) to those the user requests.

:ref:`pmr_obtain_new_packages`
   CMake relies on the ``FetchContent`` module for obtaining new packages.

:ref:`pmr_facilitate_use_of_managed_packages`
   It is the responsibility of the package maintainer to ensure the config file
   exports a target the user can use.
