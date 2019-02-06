.. _cpp_BuildRecipe_ctor-label:

cpp_BuildRecipe_ctor
####################

.. function:: _cpp_BuildRecipe_ctor(<handle> <kwargs>)

    Class storing the information required to build a dependency
    
    :Members:
    
        * name - The name of the dependency
        * version - The version of the dependency
        * src - The path to the root of the source tree.
        * args - A list of build options
    
    :param handle: An identifier to store the resulting object's handle in.
    :param kwargs: A handle to the kwargs instance to use.
    