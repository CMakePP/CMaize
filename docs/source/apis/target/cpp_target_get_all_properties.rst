.. _cpp_target_get_all_properties-label:

cpp_target_get_all_properties
#############################

.. function:: _cpp_target_get_all_properties(<result>)

    Function for returning all of the possible properties a target may have.
    
    This function is ripped from Stack Overflow: "How to print all the properties
    of a target in cmake.
    
    .. note::
    
        The resulting list contains some properties that are blacklisted for
        interface targets. See :ref:`cpp_target_get_whitelist-label` for getting
        only the whitelisted properties.
    
    :param result: The identifier to hold the returned list.
    