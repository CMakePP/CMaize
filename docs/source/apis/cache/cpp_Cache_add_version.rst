.. _cpp_Cache_add_version-label:

cpp_Cache_add_version
#####################

.. function:: _cpp_Cache_add_version(<handle> <path> <name> <ver>)

    Adds a cache entry for a particular version of a dependency
    
    This function extends :ref:`cpp_Cache_add_dependency-label` to differentiate
    between developer supplied versions, *e.g.*, 1.0, 1.1, *etc.*.
    
    :param handle: A handle to the Cache instance to use.
    :param path: An identifier which will contain the path to this dependency.
    :param name: The name of the dependency.
    :param ver: The version of the dependency.
    