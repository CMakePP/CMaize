include_guard()
include(logic/are_equal)
include(utility/set_return)

## Determines if an identifier is set to a value or not.
#
# An identifer is empty if its value is equal to the empty string. This can
# occur if:
#
# * the identifier is not defined
# * the identifier is defined, but not set
# * the identifier is defined and set to the empty string
#
# This function will return true if the identifier's value is the empty string
# and false otherwise.
#
# :param return: An identifier to hold the result.
# :param input: The identifier to check for emptyness
function(_cpp_is_empty _cie_return _cie_input)
    set(_cie_value "${${_cie_input}}")
    _cpp_are_equal(_cie_temp "${_cie_value}" "")
    _cpp_set_return(${_cie_return} ${_cie_temp})
endfunction()
