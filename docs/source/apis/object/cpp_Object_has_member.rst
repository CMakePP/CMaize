.. _cpp_Object_has_member-label:

cpp_Object_has_member
#####################

.. function:: _cpp_Object_has_member(<handle> <result> <member>)

    Determines if an object has a particular member
    
    This function wraps the mechanism for checking whether or not an object has a
    member with a particular name. It will fail if the provided handle is not
    actually a handle to an object.
    
    :param handle: The object to search for the member
    :param result: True if the object has the member and false otherwise
    :param member: The member to look for
    
    