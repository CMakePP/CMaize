.. _cpp_FindRecipe_find_dependency-label:

cpp_FindRecipe_find_dependency
##############################

.. function:: _cpp_FindRecipe_find_dependency(<handle> <hints>)

    Base implementation of find_dependency
    
    This function is responsible for launching the find recipe. It ultimately
    dispatches to the derived class's ``find_dependency`` member function after
    properly accounting for whether or not ``xxx_ROOT`` was set by the user.
    
    :param handle: A handle to a FindRecipe object detailing the search params.
    :param hints: A list of additional places to look for the dependency.
    