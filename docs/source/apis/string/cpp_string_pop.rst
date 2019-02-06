.. _cpp_string_pop-label:

cpp_string_pop
##############

.. function:: _cpp_string_pop(<return> <str>)

    Takes the first character off of a string and returns it.
    
    This function is particularly useful for when you are manually parsing a
    string character by character. This function will copy the first character
    from the string into the return and then advance the string one character
    (thinking of the string as a stream).
    
    :param return: An identifier to hold the first character of the string.
    :param str: An identifier whose value is a string. After the call the first
                character will have been removed from str.
    