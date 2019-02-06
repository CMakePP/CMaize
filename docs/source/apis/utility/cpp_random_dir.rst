.. _cpp_random_dir-label:

cpp_random_dir
##############

.. function:: _cpp_random_dir(<result> <prefix>)

    Generates a new, randomly named directory at the specified path
    
    Particularly for testing purposes we often need to generate a directory to
    store stuff in that doesn't conflict with other directories. This function
    generates a new randomly named directory in the requested directory.
    
    :param result: An identifier to hold the resulting path.
    :param prefix: The directory to create the random directory in.
    