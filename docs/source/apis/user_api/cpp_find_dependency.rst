.. _cpp_find_dependency-label:

cpp_find_dependency
###################

.. function:: cpp_find_dependency()

    Function for finding a dependency.
    
    This function is the public API for users who want CPP to find a dependency
    that the end-user is responsible for building (*i.e.*, this function is the
    public API for finding a dependency that CPP can not build). This function is
    also used internally in :ref:`cpp_find_or_build_dependency-label` to handle the
    "finding" part.
    
    :kwargs:
    
        * *NAME* (``option``) - The name of the dependency we are looking for.
        * *VERSION* (``option``) - The version of the dependency we are looking
          for.
        * *COMPONENTS* (``list``) - A list of components that the dependency must
          provide.
        * *FIND_MODULE* (``option``) - The path to a user provided find module.
        * *RESULT* (``option``) - An identifier in which to store whether or not
          the dependency was found. Result is thrown away by default.
        * *OPTIONAL* (``toggle``) - If present, failing to find the dependency is
          **NOT** an error.
    
    