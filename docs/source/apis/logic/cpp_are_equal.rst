.. _cpp_are_equal-label:

cpp_are_equal
#############

.. function:: _cpp_are_equal(<return> <lhs> <rhs>)

    Determines if the values held by two identifiers are the same
    
    This function is capable of comparing native CMake objects (strings and
    lists). Two objects are equal if their string representations are identical.
    
    :param return: An identifier to hold the result of the comparision.
    :param lhs: The value on the left of the imaginary "=="
    :param rhs: The value on the right of the imaginary "=="
    
    :Example Usage
    