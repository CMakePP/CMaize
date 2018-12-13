.. _cpp_cache_write_find_recipe-label:

cpp_cache_write_find_recipe
###########################

.. function:: _cpp_cache_write_find_recipe(<cache> <name> <module>)

    Wrapper function for generating a find-recipe and adding it to the cache.
    
    :param cache: The CPP cache to add the recipe to.
    :param name: The name of the dependency the recipe is for.
    :param module: The find module to use for locating the dependency. Set to the
        empty string if we are using config files.
    