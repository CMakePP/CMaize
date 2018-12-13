.. _cpp_dummy_cxx_library-label:

cpp_dummy_cxx_library
#####################

.. function:: _cpp_dummy_cxx_library(<prefix>)

    Creates the C++ source and header file for a simple test library
    
    This function will create a header file ``XXX.hpp`` which declares a single
    function ``int XXX_fxn()`` and a source file ``XXX.cpp``, which defines the
    function (it just makes it return 2).
    
    :param prefix: The path to use as as a source directory.
    
    :kwargs:
    
        * *NAME* (``option``) - The value of ``XXX`` in, for example, ``XXX.hpp``.
          Defaults to "a".
    
    .. note::
    
        This function does **NOT** create the ``CMakeLists.txt`` file required to
        build the resulting library.
    
    