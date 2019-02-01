include_guard()
include(logic/is_empty)
include(logic/negate)
include(utility/set_return)

## This function determines if a variable is set to a non-empty value
#
# This function simply negates :ref:`cpp_is_empty-label`.
#
# :param return: An identifier to hold the result.
# :param input: The identifier to check.
function(_cpp_is_not_empty _cine_return _cine_input)
    _cpp_is_empty(_cine_temp "${_cine_input}")
    _cpp_negate(_cine_temp "${_cine_temp}")
    _cpp_set_return(${_cine_return} ${_cine_temp})
endfunction()
