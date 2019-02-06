.. _cpp_Object_new_handle-label:

cpp_Object_new_handle
#####################

.. function:: _cpp_Object_new_handle(<var>)

    Generates a handle that can be used for a new object
    
    This function creates a CMake target that will store the state of an object.
    The resulting target will have a unique name and be mangled in such a way that
    it should not interfere with targets created by other CMake projects or for
    other CPP object instances (barring malicious intent). For all intents and
    purposes this is a private member function of the Object class.
    
    :param var: The identifier to assign the handle to
    
    