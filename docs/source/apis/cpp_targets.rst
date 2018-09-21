.. _cpp_targets-label:
.. highlight:: cmake

Targets module
==============

The ``cpp_targets`` module contains functions related to the lifetime of
targets.  This includes setting them up and installing them.

.. function:: cpp_add_library(<name> \
                              [STATIC] \
                              [CXX_STANDARD <stan>] \
                              [INCLUDE_DIR <dir>] \
                              [SOURCES [<src> ...]] \
                              [INCLUDES [<inc> ...]] \
                              [DEPENDS [<dep1> ...]])

   This function is a convenience function for setting up a library given the
   source and header files that comprise the library.  By default whether the
   library is shared or static is determined by the CMake variable
   ``BUILD_SHARED_LIBRARIES``.  Sometimes a library should always be built as a
   static library, in those rare cases the user can pass the flag ``STATIC`` to
   ``cpp_add_library`` to force the resulting library to be static regardless of
   the value of ``BUILD_SHARED_LIBRARIES``.

   .. warning:: At the moment the header files of header-only targets will not
      be visible to `cpp_install_library` when this function is used.  This is
      because CMake does not have an ``INTERFACE_PUBLIC_HEADERS`` property.  The
      workaround is to manually install your header files.  Assuming they are
      all in a directory ``my_dir`` include the following in your
      ``CMakeLists.txt``::

         install(DIRECTORY /path/to/my_dir DESTINATION ${CPP_INCDIR})

      If you have multiple directories simply repeat the above command for each
      directory.


   :param stan: Can be used to specify that the target depends on a particular
      C++ standard.  By default the value of this parameter is set to 17.
   :param dir: Can be used to set the build-time path to your library's header
      files.  This would be the path that the compiler should use with ``-I``.
      For example if your headers are ``/a/path/to/include/project/a.hpp`` and
      ``/a/path/to/include/project/b.hpp`` and are included in your C++ files
      like ``project/a.hpp`` and ``project/b.hpp` this should be set to
      ``/a/path/to/include``.  By default we set this to the root of your
      project.
   :param src: A list of source files to compile in order to form the
       library.  Paths should be full or relative to the ``cpp_add_library``
       call.
   :param inc: A list of header files to install as part of the library's
       public API.  Paths should be full or relative to the ``cpp_add_library``
       call.
   :param dep: A list of targets that this library depends on.  Each target must
       be a valid CMake target.


   CMake variables used:

   * PROJECT_SOURCE_DIR
       Used to determine the default build-time include directory

.. function:: cpp_install(TARGETS <tar1> [, <tar2> [, ...]])

   Of all the functions in CPP this is probably the most technical.  The reason
   is this function is the key to ensuring your installed project can be used by
   other CMake projects (regardless of whether they use CPP or not).  To that
   end this function does the following:

   1. Writes the ``config-version.cmake`` file

      * Used by ``find_package`` to make sure the located version is suitable
      * Assumes that requested X.Y is compatible with W.Z if X == W.

   2. Writes the ``config.cmake`` file.

      * Used by ``find_package`` to initiate the location of your project

   3. Writes the ``targets.cmake`` file

      * Used by to inform ``find_package`` of the various components of your
        project.

   4. Inform CMake that it needs to install your components.
   5. Inform CMake that it needs to install the config files

   :param tar: A list of targets to install.


   CMake variables used:

   * CMAKE_CURRENT_BINARY_DIR
        Used to make the staging area for the config files
   * CPP_project_name
        Used to provide the lowercase name of the project
   * PROJECT_VERSION
        Used to get the version of the project
   * PROJECT_NAME
        Used to...
   * CPP_SRC_DIR
        Used to find the ``Config.cmake.in`` template for ``config.cmake``
   * CPP_SHAREDIR
        Used to determine the install location for the config files
   * CPP_LIBDIR
        Used to determine where your project's libraries will be installed to.
   * CPP_BINDIR
        Used to determine where your project's executables will be installed to.
   * CPP_INCDIR
        Used to determine where your project's headers will be installed to.

