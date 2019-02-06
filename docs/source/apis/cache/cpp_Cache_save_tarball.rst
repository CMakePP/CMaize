.. _cpp_Cache_save_tarball-label:

cpp_Cache_save_tarball
######################

.. function:: _cpp_Cache_save_tarball(<handle> <path> <get_recipe>)

    Adds the tarball to the cache
    
    This function uses the GetRecipe to get the tarball. Then in an ideal world it
    places it in the cache with a name that reflects the dependency and version.
    In practice there may already be a tarball in the cache with that name. If so,
    we hash both tarballs to see if they are the same. If they are the same we
    delete the tarball we obtained and return. Otherwise we
    