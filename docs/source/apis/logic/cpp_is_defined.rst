.. _cpp_is_defined-label:

cpp_is_defined
##############

.. function:: _cpp_is_defined(<return> <input>)

    Determines if the supplied identifier is defined.
    
    In CMake an identifier can be defined or not defined. More specifically, an
    identifier is defined if it is set to some value, including the empty string.
    
    :param return: An identifier to assign the result to.
    :param input: The identifier to check for defined-ness.
    