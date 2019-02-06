.. _cpp_is_not_target-label:

cpp_is_not_target
#################

.. function:: _cpp_is_not_target(<return> <target>)

    Ensures an identifier is not currently assigned to a target
    
    This function works by negating :ref:`cpp_is_target-label`.
    
    :param return: The identifier to hold the returned value.
    :param target: The thing to check for target-ness
    