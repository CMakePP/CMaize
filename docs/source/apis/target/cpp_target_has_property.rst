.. _cpp_target_has_property-label:

cpp_target_has_property
#######################

.. function:: _cpp_target_has_property(<result> <target> <prop>)

    Function for determining if a target has a specific property
    
    For whatever reason CMake makes it a pain to determine if a target has a
    particular property set on it. This function wraps the process of doing that.
    More specifically this function first checks if the property is "whitelisted".
    If the property is not on the whitelist of properties it obviously can not be
    set on the target, so this function returns false. Assuming the property is
    allowed we next call CMake's ``get_target_property``. If the result is
    "NOTFOUND" it means that the property was not set, otherwise it was set.
    
    :param result: The identifier to use for the returned result.
    :param target: The name of the target to examine.
    :param prop: The property we are looking for.
    