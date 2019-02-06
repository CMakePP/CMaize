.. _cpp_deserialize_value-label:

cpp_deserialize_value
#####################

.. function:: _cpp_deserialize_value(<return> <buffer>)

    Dispatches to the appropriate deserialization function
    
    Deserializing JSON is considerably harder than serializing to it. If we think
    of the JSON file as a stream/buffer, then this function pulls the first
    character out of it and dispatches based on that character. The dispatched
    functions will read their respective type out of the buffer and return to this
    function the modified buffer as well as the CMake object. This function then
    returns the CMake object and the modified buffer.
    
    :param return: An identifier whose value will be set to the CMake object
                   corresponding to the next value in the JSON buffer
    :param buffer: An identifier to the JSON remaining to be parsed. The buffer
                   will be modified by this function.
    