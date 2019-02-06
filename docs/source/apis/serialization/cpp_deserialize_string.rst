.. _cpp_deserialize_string-label:

cpp_deserialize_string
######################

.. function:: _cpp_deserialize_string(<return> <buffer>)

    Deserializes a string according to the JSON standard.
    
    This function takes the buffer and strips off all characters until the closing
    ``"`` is found. The stripped off characters are put into a CMake string, which
    is then returned along with the modified buffer.
    
    :param return: An identifier to hold the deserialized string.
    :param buffer: The JSON remaining to be deserialized.
    