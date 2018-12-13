.. _cpp_handle_find_module_vars-label:

cpp_handle_find_module_vars
###########################

.. function:: _cpp_handle_find_module_vars(<name>)

    
    In the olden days of CMake one found dependencies by using find modules. For
    the most part these find modules do not create targets. Modern CMake dictates
    that each dependency should create an imported interface target that can be
    linked against. This function bridges the gap by searching for the legacy
    CMake variables and creating a target with then name of the package.
    
    This function recognizes the following legacy variables:
    
    * ``<XXX>_INCLUDE_DIRS`` for the directories containing header files
    * ``<XXX>_LIBRARIES`` for the libraries to link against
    
    In all cases ``XXX`` is the name of the dependency assuming it adheres to one
    of the following capitalization schemes:
    
    * The capitalization used as input to this function (*i.e.*, the value of
      ``name``.
    * The name of the package in all lowercase letters.
    * The name of the package in all uppercase letters.
    
    :param name: The name of the package you were looking for. This will also be
        used as the name of the resulting target.
    
    