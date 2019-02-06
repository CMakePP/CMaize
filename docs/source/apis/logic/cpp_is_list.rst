.. _cpp_is_list-label:

cpp_is_list
###########

.. function:: _cpp_is_list(<return> <list>)

    Determines if the value of an identifier is a CMake list
    
    CMake defines a list as a string that has substrings separated by semicolons.
    If the semicolons are escaped then they are not considered to be seperators.
    
    :param return: An identifier to hold the returned value
    :param list: A value to check for list-ness
    