.. _cpp_Object_set_type-label:

cpp_Object_set_type
###################

.. function:: _cpp_Object_set_type(<handle> <type>)

    Sets the type of the object
    
    This function should only be called by constructors and only after
    initializing the base class. Failure to do so will result in incorrect class
    hierarchies. Once called the class will be registered as being of the
    specified type.
    
    :param handle: The handle to the object that we are setting the type of.
    :param type: The type
    