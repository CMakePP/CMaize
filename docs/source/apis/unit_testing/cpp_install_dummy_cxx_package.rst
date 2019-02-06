.. _cpp_install_dummy_cxx_package-label:

cpp_install_dummy_cxx_package
#############################

.. function:: _cpp_install_dummy_cxx_package(<install> <prefix>)

    Function for creating and installing a dummy C++ package.
    
    This function piggybacks off of :ref:`cpp_dummy_cxx_package-label`. After the
    package is created this function additionally calls
    :ref:`cpp_run_sub_build-label`
    to build the package. The resulting package is installed to
    ``<prefix>/install``. Note that the resulting package is installed with a
    config file that can locate it. For installing a less well written library
    consider :ref:`cpp_install_naive_cxx_package-label`.
    
    :param prefix: The directory in which the package should be generated.
    :param install: The directory where the package is installed.
    :kwargs:
    
        * *NAME* - The name of the package. Defaults to "dummy".
    