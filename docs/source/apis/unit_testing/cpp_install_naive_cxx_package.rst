.. _cpp_install_naive_cxx_package-label:

cpp_install_naive_cxx_package
#############################

.. function:: _cpp_install_naive_cxx_package(<install> <prefix>)

    Writes and installs a C++ package that uses CMake naively.
    
    This function is a thin wrapper around :ref:`cpp_naive_cxx_package-label` that
    additionally builds and installs the resulting package.
    
    :param install: An identifier which, after this call, will contain the path to
        the install directory.
    :param prefix: The path to a directory which will contain both the source and
        the installed library.
    
    :kwargs:
    
        * *NAME* (``option``) - The name of the dependency. Defaults to "dummy".
    