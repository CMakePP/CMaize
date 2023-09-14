.. _cmakes_package_manager:

#######################
CMake's Package Manager
#######################

:term:`Build systems <build system>` and
:term:`package managers<package manager>` often work together to build a
:term:`project`. For better or for worse, many build systems relying on
traditional CMake attempt to be both the build system and the package manager.
Making matters worse most build systems assume that CMake is driving the
build, not a package manager. What this means is that if a build system
designer wants to enable package manager support, while still having their
package be buildable by CMake, the package manager must be integrated into
CMake.

CMaize was designed from the onset to support package managers under a CMake-
based :term:`API`. Key to this effort is establishing a package manager
component (see :ref:`designing_cmaizes_packagemanager_component`).
By default the package manager component uses what we call CMake's built-in
package manager. Admittedly, these functions are not usually discussed in this
manner and the purpose of this page is to explain how CMaize maps CMake's
existing functions to a package manager.
