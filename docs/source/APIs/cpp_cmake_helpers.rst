.. _cpp_cmake_helpers-label:

cpp_cmake_helpers module
########################

The ``cpp_cmake_helpers`` module is designed to facilitate running the ``cmake``
command in a nested capacity.

.. function:: _cpp_write_top_list(PATH <dir> NAME <name> CONTENTS <contents>)

   In order to run ``cmake`` in a nested capacity there needs to be a
   ``CMakeLists.txt`` file containing the commands we want to run.  Such a file
   requires a bit of boilerplate, which this function takes care of.  At the
   moment the boilerplate encompasses:

   * Setting the minimum CMake version
   * Declaring the project name
   * Calling ``CPPMain()``

   :param dir: The directory where the ``CMakeLists.txt`` file will be
        generated.
   :param name: The name of the project the generated ``CMakeLists.txt`` file
        configures.
   :param contents: A string containing the contents of the ``CMakeLists.txt``
        file.  The contents will be appended to the boilerplate.

   CMake variables used:

   * CMAKE_VERSION
     * Used to populate the minimum version
     * Lists generated with this command are intended for immediate use by the
       current ``cmake`` command.

