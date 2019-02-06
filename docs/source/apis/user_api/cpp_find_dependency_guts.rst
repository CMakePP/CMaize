.. _cpp_find_dependency_guts-label:

cpp_find_dependency_guts
########################

.. function:: _cpp_find_dependency_guts(<kwargs>)

    The implementation of ``cpp_find_dependency``
    
    The API of the :ref:`cpp_find_dependency-label` function is designed to be 
    native CMake because it is user facing. However, we also want to be able to 
    pass a CPP ``Kwargs`` to it. Our solution is to wrap the guts of the function
    in an API that takes a ``Kwargs`` instance and have ``cpp_find_dependency``
    build the instance for the user.
    
    :param kwargs: The ``Kwargs`` instance to use.
    