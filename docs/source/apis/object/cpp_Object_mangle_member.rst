.. _cpp_Object_mangle_member-label:

cpp_Object_mangle_member
########################

.. function:: _cpp_Object_mangle_member(<result> <name>)

    Mangles a member name for storage as a property
    
    For all intents and purposes this is a private member function of the Object
    class. Internally it is used to ensure that user provided member function
    names do not collide with properties that CMake defines already. User-defined
    member names will collide if they both call this function with the same input.
    
    :param result: The computed mangled name for the member
    :param name: The name this function will mangle
    