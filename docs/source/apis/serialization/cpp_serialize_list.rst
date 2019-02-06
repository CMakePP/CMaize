.. _cpp_serialize_list-label:

cpp_serialize_list
##################

.. function:: _cpp_serialize_list(<return> <value>)

    Serializes a CMake list into JSON format
    
    This function ultimately loops over every element of the list and then passes
    that element to :ref:`cpp_serialize_value-label`.
    
    :param return: An identifier to hold the returned list
    