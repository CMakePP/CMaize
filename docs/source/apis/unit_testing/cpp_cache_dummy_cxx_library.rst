.. _cpp_cache_dummy_cxx_library-label:

cpp_cache_dummy_cxx_library
###########################

.. function:: _cpp_cache_dummy_cxx_library(<cache> <path>)

    Wrapper function for writing the recipes for a dummy C++ library
    
    For a dummy C++ library generated with the :ref:`cpp_dummy_cxx_library-label`
    function, this function will write the appropriate recipes to the cache.
    
    :param cache: The CPP cache to write the recipes to.
    :param path: The path provided to the ``_cpp_dummy_cxx_library`` function.
    