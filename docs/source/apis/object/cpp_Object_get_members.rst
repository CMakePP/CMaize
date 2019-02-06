.. _cpp_Object_get_members-label:

cpp_Object_get_members
######################

.. function:: _cpp_Object_get_members(<handle> <result>)

    Returns the list of all members an object possess
    
    This function is largely intended for use by other Object functions. It is
    used to retrieve a list of an object's members. It does not retrieve those
    members' values. The resulting set of names is demangled so that they can be
    used through the public API of the object and will not include the internal
    members used by the Object class. This function will error if the provided
    handle is not a handle to a valid object.
    
    :param handle: The object whose members we want.
    :param result: The instance to hold the resulting list.
    
    