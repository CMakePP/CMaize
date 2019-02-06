.. _cpp_Object_add_members-label:

cpp_Object_add_members
######################

.. function:: _cpp_Object_add_members(<handle>)

    Adds a list of members to an object
    
     This function takes a handle to an object and arbitrary number of member
     names (passed via ``ARGN``). For each member name a corresponding field will
     be created on the object. This function fails if you
    
    :param handle: The object to add the members to
    :param args: The identifiers of the members.
    