.. _cpp_dependency:label:

cpp_dependency
==============

These are functions related to finding and building a dependency.

.. function:: cpp_find_dependency(<found> <name>)

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


.. function:: _cpp_build_dependency(<name>)

   This function does much of the heavy-lifting for building dependencies. It
   starts by attempting to locate the build recipe (acceptable names are:
   ``Build<name>.cmake`` and ``build-<name>.cmake``).  If the recipe is not
   found an error is raised.  After finding the recipe a sub-build is created
   and executed that runs the content of the build recipe.  It is assumed that
   the build recipe uses the functions found in cpp_build_recipes.

   :param name: The name of the dependency to build.

   CMake variables used:

   * CPP_BUILD_RECIPES
     Used to get default paths for build recipes
   * CMAKE_BINARY_DIR
     Used to make the default directory for the sub-build


.. function:: _cpp_depend_install_path(<return> <name>)

   Throughout the various functions in this file we will need to know the
   install path of a dependency.  This path is

   :param return: An identifier to use for the returned path.

   :param name: The name of the dependency.

   CMake variables used:

   * CPP_INSTALL_CACHE
   * CMAKE_TOOLCHAIN_FILE

