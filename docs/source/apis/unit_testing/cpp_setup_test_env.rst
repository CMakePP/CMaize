.. _cpp_setup_test_env-label:

cpp_setup_test_env
##################

.. function:: _cpp_setup_test_env(<name>)

    Creates a clean environment to run tests in
    
    CMake leaves a lot of environmental artificats after a run. This function
    creates a clean environment for our test so that these artificats do not
    interfere with other tests or the main CPP source code. This entails the
    following:
    
    * Creating a new directory for all test artifacts
    
        * This directory will be in the main build directory at
          ``${CMAKE_BINARY_DIR}/tests/<name>/<random>`` where ``<name>`` is the
          name provided to this function  and ``<random>`` is a randomly generated
          string.
        * For your convenience this directory will be assigned to the variable
          ``test_prefix``.
        * The path to this directory is also printed so that it appears in the log
    
    * A test-specific cache is created at ``${test_prefix}/cpp_cache``
    * The build directory is set to ``${test_prefix}``
    * A copy of the toolchain is created at ``${test_prefix}/toolchain.cmake``
    
      * The copy has been updated to reflect the aforementioned changes
    
    :param name: The name of the test case.
    
    :CMake Variables:
    
        * *CMAKE_CURRENT_SOURCE_DIR* - Used to get the staged location of the
          test.
        * *CMAKE_TOOLCHAIN_FILE* - Used by :ref:`cpp_make_test_toolchain-label`.
        * *CPP_INSTALL_CACHE* - Will be set to ``${test_prefix}/cpp_cache`` after
          this call.
    