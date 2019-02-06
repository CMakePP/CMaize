.. _cpp_Object_get_value-label:

cpp_Object_get_value
####################

.. function:: _cpp_Object_get_value(<handle> <value> <member>)

    Reads the value of an object's member
    
    This function returns the value an object's member is currently set to. It
    will crash if the provdied handle is not a target or if the object does not
    possess the requested member.
    
    :param handle: The handle to the object we are reading
    :param value: An identifier to save the value to
    :param member: The member whose value we are reading
    