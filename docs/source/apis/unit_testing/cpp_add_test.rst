.. _cpp_add_test-label:

cpp_add_test
############

.. function:: _cpp_add_test()

    
    This function implements what Catch2 would call a section. Basically it
    will run the contents of the test, in the current environment, without
    introducing the test's contents into that environment. In reality what we do
    is dump your test's contents into a CMakeList.txt and run it *via* a sub-cmake
    command. The CMake script that calls this function is treated as the
    equivalent of Catch's test case concept.
    
    .. note::
    
        Since a kwarg can't appear twice we strive to make our kwargs unique so
        that they do not conflict with those of the functions we're testing.
    
    :kwargs:
    
        * *SHOULD_FAIL* (``Toggle``) - Denotes that the test should fail. If the
          test does not fail, and this toggle is present, the test will be
          recorded as failed.
        * *REASON* (``OPTION``) - Used in combination with the *SHOULD_FAIL*
          toggle to provide the reason the test should fail. This function will
          assert that the provided text appears in the output of a failed call.
        * *TITLE* (``OPTION``) - The title of the test.
    
    :CMake Variables:
    
        * **test_prefix** - Used to get the directory the test is running in.
        * **test_number** - Used to create the working directory for the specific
          check. The value will be updated after the call to this function.
    
    