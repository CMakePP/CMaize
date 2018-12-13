.. _cpp_toolchain_additional_vars-label:

cpp_toolchain_additional_vars
#############################

.. function:: _cpp_toolchain_additional_vars(<result> <tc>)

    Function for determining the non-standard variables in a toolchain file
    
    :param result: The identifier to be used for the output. The identifier will
        be set equal to a list of identifiers found in the toolchain that are not
        part of the standard set
    :param tc: The path to the toolchain file to analyze
    