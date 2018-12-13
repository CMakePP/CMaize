.. _cpp_generate_find_recipe-label:

cpp_generate_find_recipe
########################

.. function:: _cpp_generate_find_recipe(<output> <name> <module>)

    
    The find-recipe searches for an installed version of a dependency. This
    function generates the callback to be used as the find-recipe. Ultimately,
    this has two parts: providing the appropriate find-recipe API and fixing the
    arguments to :ref:`cpp_find_recipe_dispatch`.
    
    :param output: The identifier used to hold the returned recipe.
    :param module: The path to the find module that the user provided. If no
        module was provided then pass the empty string.
    