.. _cpp_dummy_cxx_executable-label:

cpp_dummy_cxx_executable
########################

.. function:: _cpp_dummy_cxx_executable(<prefix>)

    Function for creating the source fils for a dummy C++ executable.
    
    This function is similar to :ref:`cpp_dummy_cxx_library-label` with the only
    difference being that it creates source for an executable and not a library.
    The resulting executable does nothing aside from return the number 2.
    
    :param prefix: The directory where the source should be written to. The
        resulting source file will be called ``<prefix>/main.cpp``.
    