.. _cpp_Object_has_base-label:

cpp_Object_has_base
###################

.. function:: _cpp_Object_has_base(<handle> <return> <base>)

    Determines if the object derives from a particular base class
    
    Type dispatching needs to be manually implemented. This is easiest to do if
    there's a function for determining whether an object inherits from a
    particular type or not. This is such a function.
    
    :param handle: A handle to the object whose base is being inquired about.
    :param return: An identifier to hold the result.
    :param base: The type we want to know if handle inherits from.
    