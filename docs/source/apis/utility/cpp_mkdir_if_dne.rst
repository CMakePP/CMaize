.. _cpp_mkdir_if_dne-label:

cpp_mkdir_if_dne
################

.. function:: _cpp_mkdir_if_dne(<path>)

    Code factorization for making a directory if it does not exist
    
    This function will check if a directory with the specified path already exists
    If it does not, then this function will make that directory. This function
    determines if a path is already a directory by using
    :ref:`cpp_is_directory-label`, which will return false for an identifier
    that is empty or is not defined. Obviously we can not make a directory with an
    empty path so this function additionally asserts that the path is non-empty.
    
    :param path: The path to the directory we may want to create.
    