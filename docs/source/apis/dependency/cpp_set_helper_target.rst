.. _cpp_set_helper_target-label:

cpp_set_helper_target
#####################

.. function:: _cpp_set_helper_target(<name> <handle>)

    Saves a FindRecipe to a helper target
    
    This function primarily exists to decouple us from the details of the helper
    target used to pass the FindRecipe from ``cpp_find_dependency`` to
    ``cpp_install``.
    
    :param name: The name of the dependency we are associating with the object.
    :param handle: The handle of the FindRecipe to save.
    