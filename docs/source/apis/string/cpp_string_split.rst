.. _cpp_string_split-label:

cpp_string_split
################

.. function:: _cpp_string_split(<return> <str> <substr>)

    Splits a string on the provided substring
    
    This function works similar to the Python string member split. Basically,
    given a string, this function will return a list of substrings formed by
    breaking the input string on the provided delimiter. The delimiter is not
    included in the returned strings. This function will error if the substring is
    empty.
    
    :param return: An identifier to hold the returned list.
    :param str: The string to split.
    :param substr: The substring to split on.
    
    :Example Usage:
    
    .. code-block:: cmake
    
        Split the string "hello world" on the space character
        _cpp_string_split(list "hello world" " ")
        _cpp_assert_equal("${list}" "hello;world")
    
        Split on the "ll"
        _cpp_string_split(list "hello world" "ll")
        _cpp_assert_equal("${list}" "he;o world")
    
        Split on the "d"
        _cpp_string_split(list "hello world" "d")
        _cpp_assert_equal("${list}" "hello worl;") Note the trailing ";"
    
    