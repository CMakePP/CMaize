.. _cpp_main-label:

cpp_main module
###############

The ``cpp_main`` module contains the code for initializing the CMake environment
for use with CPP.  All projects that use CPP will call ``CPPMain()``, the call
is inside CPP's config file and does not have to be done manually by the user.
Nonetheless for finer control over the build process the user should be familiar
with the ``CPPMain()`` function.

.. function:: CPPMain()

   This function initializes the environment so that CPP can run.  This entails
   several steps:

   1. Set options pertaining to how CPP should run
   2. Set CMake options that influence the
   3. Determine the installation paths
   4. Set up RPath settings
   5. Generate a toolchain file (if the user did not provide one)

   *N.B.* check out :ref:`cpp_toolchain-label` for a list of CMake variables
   that will be written to the toolchain file and note that not all variables
   set by this function will be.

   The following CMake variables will be used by ``CPPMain`` and treated as
   options (*i.e.*, CPP will set default values if the user does not provide a
   value they would like to use):

   * CPP_DEBUG_MODE
        * Should additional CPP status information be printed?
        * Default is true
   * CPP_INSTALL_CACHE
        * Where dependencies will be installed.
        * Default is ``$ENV{HOME}/.cpp_cache``
   * CPP_FIND_RECIPES
        * List of paths for locating dependency locating recipes.
        * Default is ``${PROJECT_SOURCE_DIR}/cmake/find_external``
   * CPP_BUILD_RECIPES
        * List of paths for locating dependency building recipes.
        * Default is ``${PROJECT_SOURCE_DIR}/cmake/build_external``
   * CMAKE_BUILD_TYPE
        * What sort of build should the assets use?
        * Default is debug
   * BUILD_SHARED_LIBS
        * Should assets be compiled into shared libraries?
        * Default is true.
   * CPP_NAMESPACE
        * Directory used to "namespace" protect installed files
        * Default is the lowercase project name.
   * CPP_LIBDIR
        * Directory where your project's libraries will be installed
        * Default is ``${CMAKE_INSTALL_LIBDIR}/${CPP_NAMESPACE}``
   * CPP_BINDIR
        * Directory where your project's binaries/scripts will be installed
        * Default is ``${CMAKE_INSTALL_BINDIR}/${CPP_NAMESPACE}``
   * CPP_INCDIR
        * Directory where your project's libraries will be installed
        * Default is ``${CMAKE_INSTALL_INCLUDEDIR}/${CPP_NAMESPACE}``
   * CPP_SHAREDIR
        * Directory where your project's config files will be installed
        * Default is ``share/cmake/${CPP_NAMESPACE}``
   * CMAKE_TOOLCHAIN_FILE
        * Path to a file that sets the values of important variables
        * See :ref:`cpp_toolchain-label` for details pertaining to the default
          generated one.


   Additional CMake variables used:

   * PROJECT_SOURCE_DIR
        Used to construct the default recipe paths
   * PROJECT_NAME
        Used to construct the lowercase version of the project's name
   * CMAKE_PLATFORM_IMPLICIT_LINK_DIRECTORIES
        Used to make sure we don't include system libraries in the RPATH


   Additional CMake variables set:

   * CMAKE_SKIP_BUILD_RPATH
        Set to false so that libraries use the full RPATH while being built
   * CMAKE_BUILD_WITH_INSTALL_RPATH
        Makes the building phase use the build RPATHs and changes them to the
        install RPATHs when installing
   * CMAKE_INSTALL_RPATH_USE_LINK_PATH
        Set to true because the install RPATHs are assumed to be those found at
        link time.
   * CPP_INSTALL_RPATH
        Set to the install RPATH for your project



   Environment variables used:

   * HOME
        Used to construct the default install cache path
