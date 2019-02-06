.. _cpp_FindRecipe_ctor-label:

cpp_FindRecipe_ctor
###################

.. function:: _cpp_FindRecipe_ctor(<handle> <kwargs>)

    Base class for recipes aiming to find dependencies.
    
    :Members:
    
      * name - The name of the dependency as it should be passed to ``find_package``
      * version - The version of the dependency we are looking for.
      * components - Which components of the dependency are we looking for?
      * root - Where the user told us to look via ``xxx_ROOT``.
      * paths - Once found the list of paths needed to find the dependency
      * found - A flag indicating whether or not the dependency has been found.
    
    .. note::
    
        The contents of the ``paths`` member is not necessarilly the smallest set
        of paths required to find the dependency. Typically this member contains
        the contents of ``CMAKE_PREFIX_PATH`` as well as any hints provided to us
        such as from the cache or from ``xxx_ROOT`` variables. Basically, once we
        find a dependency we dump all paths that could possibly have been used to
        find it into this variable with the hope that if later we set
        ``CMAKE_PREFIX_PATH`` to the contents of this member we can find the
        dependency again.
    
    :param handle: An identifier to store the handle to the created object
    :param kwags: A handle to the kwargs the ctor should use
    
    :CMake Variables:
    
      * *<Name>_ROOT* - Here ``<Name>`` matches the capitalization of the ``name``
        variable.
      * *<NAME>_ROOT* - Here ``<NAME>`` is the value of the ``name`` variable in
        all capital letters.
      * *<name>_ROOT* - Here ``<name>`` is the value of the ``name`` variable in
        all lowercase letters.
    