.. _standard_cmake-label:

CMake Option Variables
======================

This page collects CMake variables that can be used as options to the
CMake command to control the resulting build.  Projects are strongly encouraged
to use these variables when relevant and under no circumstance should a
project override any of these variables.

Standard CMake Variables
------------------------

These are variables that are defined by CMake itself and therefore should be
honored by all projects using CMake regardless of whether or not they used CPP.
Note that the inopportune word there is **should**; you'll find a plethora of
counterexamples (said counterexamples are bugs and should be reported).

CMAKE_XXX_COMPILER
^^^^^^^^^^^^^^^^^^

Here ``XXX`` can be ``CXX``, ``C``, or ``Fortran``.  This variable can be used
to specify the compiler for language ``XXX``.  It is strongly recommended that
you use full paths otherwise weirdness can occur.

CMAKE_XXX_FLAGS
^^^^^^^^^^^^^^^

Again ``XXX`` can be ``CXX``, ``C``, or ``Fortran``.  This variable can be used
to hold a list of flags that should be given to the ``XXX`` compiler.

CMAKE_TOOLCHAIN_FILE
^^^^^^^^^^^^^^^^^^^^

Used to point to the toolchain file.  CPP will automatically forward the
toolchain file to dependencies.  See :ref:`toolchains-label` for more
information on writing a toolchain file.

CMAKE_INSTALL_PREFIX
^^^^^^^^^^^^^^^^^^^^

This is the directory to use as the root of the installation.  This defaults to
something like ``/usr/local`` on Unix-like operating systems.

CMAKE_PREFIX_PATH
^^^^^^^^^^^^^^^^^

This is a list of paths that CMake should search in order to locate a package.
Of note you will likely need to set this variable to the location of CPP when
compiling a project that relies on CPP (unless you install CPP system-wide).

BUILD_SHARED_LIBRARIES
^^^^^^^^^^^^^^^^^^^^^^

This can be used to control whether or not the resulting libraries will be
shared or static.  Note that this is only honored if package maintainers do not
force a library to be static/shared.

XXX_ROOT
^^^^^^^^

Many of the old ``FindXXX.cmake`` modules used such variables as hints for
where a dependency ``XXX`` is installed.  CMake has now adopted such variables
as part of the standard and ``find_package`` automatically considers such
variables as hints, regardless of whether the module recognizes the variable or
not. CMake only strictly honors ``XXX_ROOT`` where ``XXX`` matches the case of
the dependency's name; however, since determining the case can be annoying, CPP
additionally will honor the all uppercase and all lowercase variants.

CPP Specific Variables
----------------------

CPP_GITHUB_TOKEN
^^^^^^^^^^^^^^^^

Used to authenticate the user for a private GitHub repository.  The value of
this variable should be set to the token.  The token needs to be generated to
minimally have read access to the repository.  See
`here <https://help.github.com/articles/creating-a-personal-access-token-for-
the-command-line/>`_ for more information on generating tokens.

CPP_INSTALL_CACHE
^^^^^^^^^^^^^^^^^

This variable controls where dependency and CPP files should be installed. It
defaults to ``<build_dir>/cpp_cache``, where ``build_dir`` is the path specified
for the build directory when the package was configured.
