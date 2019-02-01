include_guard()
include(logic/is_empty)
include(logic/is_not_directory)

## Code factorization for making a directory if it does not exist
#
# This function will check if a directory with the specified path already exists
# If it does not, then this function will make that directory. This function
# determines if a path is already a directory by using
# :ref:`is_directory-label`, which will return false for an identifier
# that is empty or is not defined. Obviously we can not make a directory with an
# empty path so this function additionally asserts that the path is non-empty.
#
# :param path: The path to the directory we may want to create.
function(_cpp_mkdir_if_dne _cmid_path)
    _cpp_is_empty(_cmid_empty _cmid_path)
    if(_cmid_empty)
        _cpp_error("Path can not be empty.")
    endif()

    _cpp_is_not_directory(_cmid_temp "${_cmid_path}")
    if(_cmid_temp)
        file(MAKE_DIRECTORY ${_cmid_path})
    endif()
endfunction()
