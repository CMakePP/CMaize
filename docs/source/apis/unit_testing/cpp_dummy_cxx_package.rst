.. _cpp_dummy_cxx_package-label:

cpp_dummy_cxx_package
#####################

.. function:: _cpp_dummy_cxx_package(<dir> <prefix>)

    Function for creating a C++ package for testing purposes.
    
    This function uses :ref:`cpp_dummy_cxx_library-label` to generate C++ source
    code for a simple library. In addition to the source code, this function also
    creates a ``CMakeLists.txt`` that can be used to build the package. The
    resulting ``CMakeLists.txt`` is written in terms of CPP commands and will
    create config files for finding the dependency upon installation. For testing
    less well written CMake projects use :ref:`cpp_naive_cxx_package-label`.
    
    :param dir: An identifier which upon return will contain the path to the
                package's root directory.
    :param prefix: The directory where the package will be created. The source for
        the resulting package will reside at ``<prefix>/<name>``.
    
    :kwargs:
    
        * *NAME* (``option``) - The name of the package we are creating. Defaults
          to dummy.
    