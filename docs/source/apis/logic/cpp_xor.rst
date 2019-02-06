.. _cpp_xor-label:

cpp_xor
#######

.. function:: _cpp_xor(<return>)

    Ensures that only one of the provided identifiers is set to a true value
    
    Logic in CMake is a pain. This function implements xor on an arbitrary number
    of inputs and will return true if one, and only one, of them is true. The
    return will be false in all other instances.
    
    :param return: True if only one of the identifiers is true.
    :param args: A variadic list of identifiers to check for truth-ness.
    