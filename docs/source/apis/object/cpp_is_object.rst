.. _cpp_is_object-label:

cpp_is_object
#############

.. function:: _cpp_is_object(<return> <input>)

    Determines if the input is a handle to a valid CPP object
    
    All CPP objects inherit from the ``Object`` base class. This function simply
    ensures that there is a target corresponding to that
    
    :param return: The identifier to assign the result to.
    :param input: The thing to consider for being a handle to an object
    