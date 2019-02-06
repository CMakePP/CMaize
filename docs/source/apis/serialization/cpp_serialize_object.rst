.. _cpp_serialize_object-label:

cpp_serialize_object
####################

.. function:: _cpp_serialize_object(<return> <handle>)

    Serializes a CPP object into JSON format
    
    This function ultimately loops over every member of the object and then passes
    that element to :ref:`cpp_serialize_value-label`.
    
    :param return: An identifier to hold the returned object
    :param handle: A handle to an object
    