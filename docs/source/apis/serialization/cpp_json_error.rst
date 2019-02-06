.. _cpp_json_error-label:

cpp_json_error
##############

.. function:: _cpp_json_error(<buffer>)

    Code factorization for reporting a string as invalid JSON
    
    As we deserialize a JSON string we are constantly checking to make sure that
    the string is valid JSON. If it is not we raise an error. The purpose of this
    function is to ensure that that error is uniformly printed.
    
    :param buffer: An identifier whose contents is not valid JSON
    