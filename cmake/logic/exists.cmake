include_guard()
include(utility/set_return)

## Determines if a provided path points to a valid file or directory
#
# Given a filesystem path this function will return true if that path is a valid
# path for a file or a directory. It will return false otherwise.
#
# :param return: An identifier to hold the returned value.
function(_cpp_exists _ce_return _ce_path)
    if(EXISTS ${_ce_path})
        _cpp_set_return(${_ce_return} 1)
    else()
        _cpp_set_return(${_ce_return} 0)
    endif()
endfunction()
