.. _cpp_serialize_string-label:

cpp_serialize_string
####################

.. function:: _cpp_serialize_string(<return> <value>)

    Serializes a string according to the JSON standard.
    
    Since CMake doesn't distinguish between strings, numbers, and booleans this
    function is actually responsible for serializing all of them. The actual
    serialization process is trivial, we just return the value in escaped double
    quotes.
    
    :param return: An identifier to hold the serialized string.
    :param value: The string to serialize
    