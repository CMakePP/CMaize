.. _cpp_is_target-label:

cpp_is_target
#############

.. function:: _cpp_is_target(<return> <target>)

    Determines if the input is a target
    
    This function wraps CMake's mechanism for branching based on whether or not
    the string maps to a registered target.
    
    :param return: Identifier to hold whether or not the input is a valid target
    :param target: The string to test for target-ness
    