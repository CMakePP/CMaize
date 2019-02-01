include_guard()
include(logic/exists)
include(logic/negate)
include(utility/set_return)

## Returns true if the provided path does not point to a file or directory
#
# This function simply negates :ref:`cpp_exists-label`.
#
# :param return: An identifier to hold the result.
# :param path: The path to check.
function(_cpp_does_not_exist _cdne_return _cdne_path)
    _cpp_exists(_cdne_temp "${_cdne_path}")
    _cpp_negate(_cdne_temp "${_cdne_temp}")
    _cpp_set_return(${_cdne_return} ${_cdne_temp})
endfunction()
