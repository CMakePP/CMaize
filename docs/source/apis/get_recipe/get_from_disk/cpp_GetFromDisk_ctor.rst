.. _cpp_GetFromDisk_ctor-label:

cpp_GetFromDisk_ctor
####################

.. function:: _cpp_GetFromDisk_ctor(<handle> <path> <kwargs>)

    A GetRecipe capable of retreiving source code from disk
    
    This class extends the GetRecipe class by adding a member ``dir`` that stores
    the path to the source code.
    
    :param handle: An identifier to store the handle for the created object.
    :param path: The path to the source code
    
    :kwargs:
    
      * *NAME*    - The name of the dependency.
      * *VERSION* - The version of the source code the path points to.
    