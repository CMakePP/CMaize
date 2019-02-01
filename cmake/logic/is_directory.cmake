include_guard()
include(utility/set_return)

## Indicates whether a path points to a directory or not.
#
# This function will return true if the provided path points to a directory,
# otherwise it will return false.
#
# :param return: An identifier to hold the result.
# :param path: The path whose directory-ness is in question.
function(_cpp_is_directory _cid_return _cid_path)
    if(IS_DIRECTORY "${_cid_path}")
        _cpp_set_return(${_cid_return} 1)
    else()
        _cpp_set_return(${_cid_return} 0)
    endif()
endfunction()
