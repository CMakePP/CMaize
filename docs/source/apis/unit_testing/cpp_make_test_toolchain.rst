.. _cpp_make_test_toolchain-label:

cpp_make_test_toolchain
#######################

.. function:: _cpp_make_test_toolchain(<prefix>)

    Function that modifies the real toolchain into one for testing
    
    While running tests we need a toolchain that we can freely modify without
    fears of clobbering the real toolchain. This testing toolchain also needs to
    have its value of the CPP cache updated to the testing version. Those are this
    function's main tasks. After calling this function the value of
    ``CMAKE_TOOLCHAIN_FILE`` will be updated to point to the testing toolchain.
    
    :param prefix: The effective binary directory for this test.
    
    :CMake Varaibles:
    
        * *CMAKE_TOOLCHAIN_FILE* - Used to get the current toolchain. The value
          of this variable will be set to ``${test_prefix}/toolchain.cmake`` after
          this call.
    