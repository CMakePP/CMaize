include_guard()

include(logic/is_directory)
include(logic/negate)
include(utility/set_return)

## Determines if a path does not point to a directory
#
# This function simply negates :ref:`cpp_is_directory-label`.
#
# :param return: An identifier to hold the result.
# :param path: The path whose directoryless-ness is in question.
function(_cpp_is_not_directory _cind_return _cind_path)
    _cpp_is_directory(_cind_temp "${_cind_path}")
    _cpp_negate(_cind_temp "${_cind_temp}")
    _cpp_set_return(${_cind_return} ${_cind_temp})
endfunction()
