.. _cpp_string_cases-label:

cpp_string_cases
################

.. function:: _cpp_string_cases(<return> <input>)

    Generates common case-variants of a string
    
    CMake is unfortunately case-sensitive while relying on a string-based variable
    system. This means that many of CMake's built-in functions have no tolerance
    when it comes to the case of the strings the user provides. This function
    will take a user's input and generate all common case variants of it, which at
    the moment includes: input case, uppercase, and lowercase.
    
    :param return: An identifier to hold the list of common variants.
    :param input: The string we want common cases of.
    