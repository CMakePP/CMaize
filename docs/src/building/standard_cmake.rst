.. _CMake-Option-Variables:

**********************
CMake Option Variables
**********************

This page collects CMake variables that can be used as options to the `cmake`
command to control the resulting build.  Projects are strongly encouraged to use
these variables when relevant and under no circumstance should a project
override any of these variables (in rare circumstances appending to them may be
needed, but you should never override them). The variables in this chapter are
defined by CMake itself and therefore should be honored by all projects using
CMake regardless of whether or not they used CMakePP. Note that the inopportune
word there is **should**; you'll find a plethora of counterexamples (said
counterexamples are bugs and should be reported).

Controlling CMake
=================

The variables in this section control CMake's behavior.

CMAKE_TOOLCHAIN_FILE
--------------------

Used to tell CMake to read the input variables from a file. In other words,
instead of having to pass a bunch of ``-D<variable>=<value>`` flags to the
``cmake`` command, you can put them in a file and CMake will read them in. The
variables must be specified in the file using CMake's set syntax:
``set(<variable> <value>)``.

CMAKE_INSTALL_PREFIX
--------------------

This is the directory to use as the root of the installation.  This defaults to
something like ``/usr/local`` on Unix-like operating systems.

Finding Dependencies
====================

Variables in this section are used by CMake when it looks for a dependency.

CMAKE_PREFIX_PATH
-----------------

This is a list of paths that CMake should search in order to locate a package.
For dependencies which follow modern CMake practices this should be the path to
the directory containing the ``XXXConfig.cmake`` file. For dependencies still
relying on ``FindXXX.cmake`` modules this is usually the path to the include and
library directories.

XXX_ROOT
--------

Many of the old ``FindXXX.cmake`` modules used such variables as hints for
where a dependency ``XXX`` is installed.  CMake has now adopted such variables
as part of the standard and ``find_package`` automatically considers such
variables as hints, regardless of whether the module recognizes the variable or
not. CMake only strictly honors ``XXX_ROOT`` where ``XXX`` matches the case of
the dependency's name; however, since determining the case can be annoying,
CMakePP additionally will honor the all uppercase and all lowercase variants.

CMAKE_MODULE_PATH
-----------------

This is where CMake looks for other CMake modules. This is only relevant if your
dependency is a CMake module that has not been installed.

Compilation
===========

The variables in this section influence what gets compiled and how it gets
compiled.

BUILD_SHARED_LIBRARIES
----------------------

This can be used to control whether or not the resulting libraries will be
shared or static.  Note that this is only honored if package maintainers do not
force a library to be static/shared.

BUILD_TESTING
-------------

If set to a true value CMake will build unittests, otherwise the unittests will
be skipped.

CMAKE_BUILD_TYPE
----------------

Used to switch between various build types (debug, release, *etc.*). CMake by
default recognizes `Debug`, `Release`, `MinSizeRel`, and `RelWithDebInfo`, but
CMake projects are free to define additional build types if they so choose.

CMAKE_XXX_COMPILER
------------------

Here ``XXX`` can be ``CXX``, ``C``, or ``Fortran``.  This variable can be used
to specify the compiler for language ``XXX``.  It is strongly recommended that
you use full paths otherwise weirdness can occur.

CMAKE_XXX_FLAGS
---------------

Again ``XXX`` can be ``CXX``, ``C``, or ``Fortran``.  This variable can be used
to hold a list of flags that should be given to the ``XXX`` compiler.
