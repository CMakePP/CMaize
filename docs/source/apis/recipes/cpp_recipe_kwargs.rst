.. _cpp_recipe_kwargs-label:

cpp_recipe_kwargs
#################

.. function:: _cpp_recipe_kwargs(<toggles> <options> <lists> <type>)

    Function providing the kwargs recognized by each recipe type
    
    Each of the various recipe types supports a number of kwargs. For the user's
    convenience we allow the union of those kwargs as input to
    :ref:`cpp_find_dependency-label` and :ref:`cpp_find_or_build_dependency`.
    This in turn means we need to parse the kwargs at several levels. This
    function decouples those parsing points from the list of available kwargs.
    
    .. note::
    
        If two recipes take the same kwarg they must use it for identical
        purposes.
    
    :param toggles: An identifier to store the toggles the recipe recognizes.
    :param options: An identifier to store the options the recipe recognizes.
    :param lists: An identifer to store the lists the recipe recognizes.
    :param type: The recipe type. Must be "BUILD", "GET", or "FIND".
    
    