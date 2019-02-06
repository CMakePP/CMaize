.. _cpp_Object_set_value-label:

cpp_Object_set_value
####################

.. function:: _cpp_Object_set_value(<handle> <member> <value>)

    Sets the member of a class to a given value
    
    This function will set the specified member to the provided value. The
    function will error if the specified handle is not an object or if the object
    does not have the specified member.
    
    :param handle: The handle of the object to set
    :param member: The name of the member to set
    :param value: The value to set the member to
    