.. _cpp_Object_are_equal-label:

cpp_Object_are_equal
####################

.. function:: _cpp_Object_are_equal(<lhs> <return> <rhs>)

    Determines if two objects have the same state.
    
    We define two CPP objects as equal if they have the same members and if each
    of those members is set to the same state.
    
    :param return: An identifier to hold whether or not the two objects are the
                   same.
    :param lhs: The handle for the object that goes on the left of ``==``
    :param rhs: The handle for the object that goes on the right of ``==``
    