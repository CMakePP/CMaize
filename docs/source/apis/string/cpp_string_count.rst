.. _cpp_string_count-label:

cpp_string_count
################

.. function:: _cpp_string_count(<return> <substr> <str>)

    
    Given a string, this function will determine how many times a particular
    substring appears in that string. Since CMake values are intrinsically
    convertible to strings this function can also be used to determine how many
    times an element appears in a list.
    
    .. note::
    
        This function does not limit its search to whole words. That is to say, if
        you search for a string "XXX" then it will return 1 for the string
        "FindXXX.cmake".
    
    :param return: The identifier this function should assign the result to.
    :param substr: The substring to search for.
    :param str: The string to search in.
    