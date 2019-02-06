.. _cpp_BuildWithModule_build_dependency-label:

cpp_BuildWithModule_build_dependency
####################################

.. function:: _cpp_BuildWithModule_build_dependency(<handle> <install>)

    Implements ``build_dependency`` for the BuildWithModule class
    
    User specified build modules are required to define a function
    ``user_build_module`` that takes a path to the root of the source it is to
    build and the path where the package should be installed. The module is
    responsible for filling in the gaps.
    
    :param handle: An identifier holding a handle to a BuildWithModule instance.
    :param install: The path to where the dependency should be installed.
    