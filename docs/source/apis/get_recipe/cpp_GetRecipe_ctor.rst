.. _cpp_GetRecipe_ctor-label:

cpp_GetRecipe_ctor
##################

.. function:: _cpp_GetRecipe_ctor(<handle> <kwargs>)

    Constructor for the GetRecipe  baseclass
    
    Get recipes are responsible for being able to get a tarball of a dependency's
    source code. There are a variety of mechanisms for doing this and each one of
    those mechanisms is implemented as class derived from the ``GetRecipe`` class.
    
    Members:
    
    * name - The name of the dependency this recipe is for.
    * version - The version of the dependency this recipe is for.
    
    :param handle: The identifier that will hold the newly created object
    :param version: The version of the dependency this recipe is for. If blank the
                    version will be set to "latest"
    