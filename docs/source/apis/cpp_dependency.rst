.. _cpp_dependency-label:

cpp_dependency Module
=====================

These are functions related to finding and building a dependency.

.. _cpp_find_dependency-label:

cpp_find_dependency
-------------------

.. function:: cpp_find_dependency(<name> [OUTPUT <found>])

   This function is a wrapper over CMake's ``find_package`` that sanitizes the
   process and simplifies it from the user's perspective.  We assume there's
   three possibilities:

   * The user wants us to use a specific version of the package.
   * The dependency is in CPP's cache
   * The dependency is discoverable by CMake

   These possibilities are also listed in order of precedence (*e.g.*, the
   version of a dependency specified by the user will be used even if there is
   one in the cache).  The order ensures the user always has the final say and
   that we prefer versions of the dependency we have built ourselves.  Note that
   CMake does not provide a mechanism for limiting the paths used by the find
   scripts so it is up to the writers of such scripts to write them in a
   sensible manner.

   :param found: An identifier for the return value, which indicates whether
   the dependency was found or not.

   :param name: The name of the dependency to locate.

.. _cpp_find_or_build_dependency-label:

cpp_find_or_build_dependency
----------------------------

.. function:: cpp_find_or_build_dependency(<name> (RECIPE <recipe> || \
                                                   PATH <path>     || \
                                                   URL <url> [BRANCH <branch>]\
                                                   VIRTUAL <imp1> [<imp2> ...])

   This function attempts to make it easy for a user of CPP to add a dependency
   that can optionally be built by CPP if it is not found.  It requires two
   pieces of information: the name of the dependency and a mechanism for
   building the dependency.  At the moment three mechanisms are recognized:
   downloading the source, using source that is locally available on the
   machine, or using a build recipe.  The latter is a catch-all that can be used
   when the build process is not "ideal".  These mechanisms are mutually
   exclusive and an error will be raised if you try to mix them in the same
   call.

   :param name: The name of the dependency.
   :param recipe: The path to the build recipe to use.
   :param path: The path to the root of the source tree.
   :param url: The URL to use to download the source.
   :param branch: The branch of the repository to use.
   :param imp: A list of implementations for a particular virtual dependency.

   CMake variables used:

   * CMAKE_BINARY_DIR - For storing build recipes we generate on the fly.

.. __cpp_build_dependency-label:

_cpp_build_dependency
---------------------

.. function:: _cpp_build_dependency(<name> <path>)

   This function wraps the building of a dependency given a recipe.  It is code
   factorization to make ``cpp_find_or_build_dependency`` easier to debug.

   :param name: The name of the dependency to build.
   :param path: Path to the recipe to use.


   CMake variables used:

        * CMAKE_BINARY_DIR
     Used to make the default directory for the sub-build

.. __cpp_depend_install_path-label:

_cpp_depend_install_path
------------------------

.. function:: _cpp_depend_install_path(<return> <name> [CPP_CACHE <cache>]\
                                       [PROJECT_NAME <pname>]\
                                       [TOOLCHAIN_FILE <file>])

    For a given dependency this function will generate the path for installing
    it.  The resulting path is a function of the dependency's name, the
    project's name, and a hash of the toolchain.

   :param return: An identifier to use for the returned path.

   :param name: The name of the dependency.

   :param cache: The path to the CPP cache where we will install the dependency.
   Defaults to the value of the ``${CPP_INSTALL_CACHE}``.

   :param pname: The name of the project we are building the dependency for.
   Defaults to the value of ``${PROJECT_NAME}``.

   :param file: The path to the toolchain file.  Defaults to the value of
   ``${CMAKE_TOOLCHAIN_FILE}``.


   CMake variables used:

   * CPP_INSTALL_CACHE
   * CMAKE_TOOLCHAIN_FILE
   * PROJECT_NAME

