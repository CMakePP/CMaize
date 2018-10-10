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
     * Lists are intended for use with the same ``cmake`` executable only

.. function:: _cpp_run_cmake_command(COMMAND <cmd>\
                                     [OUTPUT <out>]\
                                     [BINARY_DIR <bin>]\
                                     [RESULT <var>]\
                                     [INCLUDES <inc1> [, <inc2> [, ...]]]\
                                     [CMAKE_ARGS <arg1>=<value1>\
                                                 [, <arg2>=<value2> [, ...]]]\
                                     )

   This function actually calls ``cmake`` in a nested facility.  This is done by
   writing the command to a file and then having ``cmake`` run the file in
   script mode.  Unlike ``_cpp_run_sub_build`` the caller of the function is not
   required to have created a CMake script ahead of time, nor will this call
   make things like a CMake cache.  On the other hand, CMake functions are
   restricted to those available in scripting mode.  The other big difference
   between this and ``_cpp_run_sub_build`` is that the CMake command run is
   allowed to fail.

  :param cmd: The actual command to be run.
  :param out: Specifies the identifier that should hold all printing output.
  :param bin: Optionally allows you to specify what directory will hold the
      scratch file.  Defaults to the current build directory.
  :param var: An identifier to save the status of the command to.  The value
      will be 0 for a successful run (in my experience it is always 1 for
      failed runs, but I'm not sure it always will be).
  :param inc1: The first CMake module that should be included before running
      the command.
  :param inc2: The second CMake module that should be included before running
      the command.
  :param arg1: The first identifier to define.
  :param value1: The value to assign to the first identifier.
  :param arg2: The second identifier to define.
  :param value2: The value to assign to the second identifier.

  CMake variables used:

  * CMAKE_BINARY_DIR
        For establishing the default scratch directory to hold the file
  * CMAKE_TOOLCHAIN_FILE
        To forward the toolchain.
  * CMAKE_COMMAND
        To call the ``cmake`` executable.

.. function:: _cpp_run_sub_build(<dir>\
                                 (NO_INSTALL || INSTALL_PREFIX <pfx>)\
                                 [OUTPUT <var>]\
                                 [CMAKE_ARGS <arg1>=<value1> \
                                             [, <arg2>=<value2> [, ...]]]\
                                 )

   This function will configure, build, and install (unless the ``NO_INSTALL``
   flag is provided) a CMake project from within another CMake project
   (specifically from within another invocation of the ``cmake`` command).
   Unlike ``_cpp_run_cmake_command``, CMake will be run in full-fledged mode
   *i.e.*, it is not run in scripting mode.  This means scripts run with this
   command have access to the full arsenal of CMake functions.  It also means
   that there will be files associated with a build (CMake cache as well as the
   usual ``CMakeFiles`` directories) that need to be accounted for.

   :param dir: The root directory of the CMake project to build.
   :param pfx: The path to be used for ``CMAKE_INSTALL_PREFIX``.  Unless
        ``NO_INSTALL`` is specified this is a required keyword argument.  Note
        specifying an install prefix when ``NO_INSTALL`` is also present will
        cause ``CMAKE_INSTALL_PREFIX`` to be set to the value provided and
        passed to the configuration step, *i.e.*, the configuration step may
        still use the value, but the install step will not be invoked.
   :param var: The identifier to save the output to.  If specified the output
        of the configure, build, and install (assuming the install phase is not
        skipped) will be concatenated into one string and the value stored under
        the provided identifier.
   :param arg1: The first identifier to pass to the nested ``cmake`` command.
   :param value1: The value to set the first identifier to.
   :param arg2: The second identifier to pass to the nested ``cmake`` command.
   :param value2: The value to set the second identifier to.
