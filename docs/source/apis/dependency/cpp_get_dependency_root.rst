.. _cpp_get_dependency_root-label:

cpp_get_dependency_root
#######################

.. function:: _cpp_get_dependency_root(<root> <name>)

    Function that determines the root of an already found dependency's install
    
    If we find a dependency we create a helper target. That helper target has a
    property INTERFACE_INCLUDE_DIRECTORIES that is either set to:
    
    - set(Name_DIR XXX) (if it was found by a config file)
    - set(Name_ROOT XXX) (if it was found by a module file)
    
    This function will parse that string and extract the XXX from it if it is the
    second case. In all other instances the return will be set to the name of the
    return appended with "-NOTFOUND"
    
    :param root: An identifier to hold the result
    :param name: The name of the dependency
    
    