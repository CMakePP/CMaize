.. _cpp_build_recipes-label:

cpp_build_recipes module
########################

The functions in the ``cpp_build_recipes`` module are designed to replace the
large amount of boilerplate required for filling out the ``ExternalProject_Add``
function in a series of common scenarios.  Consequentially, this facilitates
users writing their own build recipes for CPP.

.. function:: cpp_local_cmake(<name> <dir>)

   :param name: The name of the dependency.  This should be the name of the
       dependency as it would be passed to ``find_package``.

   :param dir: The full path to the directory containing the top-level
       ``CMakeLists.txt`` for the dependency.

   CMake variables used:

   * CMAKE_BINARY_DIR
     Used to specify where the dependency should be staged.
   * CMAKE_TOOLCHAIN_FILE
   * CMAKE_INSTALL_PREFIX

.. function:: _cpp_parse_gh_url(<return> <url>)

   I do not expect users to utilize the GitHub URL API, consequentially we need
   a way to turn a normal GitHub URL (something like
   https://github.com/ryanmrichard/CMakePackagingProject) into the API variant
   (something like
   https://api.github.com/repos/ryanmrichard/CMakePackagingProject/tarball...)

   :param return: The identifier to be used for returning the result.
   :param url: The GitHub URL to
