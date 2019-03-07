.. _cpp_Object_add_function-label:

cpp_Object_add_function
#######################

.. function:: _cpp_Object_add_function(<handle> <name> <path>)

    Adds a member function to a class.
    
    To store a member function we use double dispatch. First we store the mangled
    name without the type. The value of this member is a list of mangled names
    that implement/override the function. Then for each of these mangled names we
    create a new ``Function`` instance and save it under the mangled name.
    
    :param handle: The handle of the object we are adding the function to.
    :param name: The name of the function.
    :param path: The path to the implementation of the function
    