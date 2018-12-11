include_guard()

## Function for determining how many times a substring appears in a string.
#
# Given a string, this function will determine how many times a particular
# substring appears in that string. Since CMake values are intrinsically
# convertible to strings this function can also be used to determine how many
# times an element appears in a list.
#
# .. note::
#
#     This function does not limit its search to whole words. That is to say, if
#     you search for a string "XXX" then it will return 1 for the string
#     "FindXXX.cmake".
#
# :param return: The identifier this function should assign the result to.
# :param substr: The substring to search for.
# :param str: The string to search in.
function(_cpp_string_count _csc_return _csc_substr _csc_str)
    string(REGEX MATCHALL "${_csc_substr}" _csc_matches "${_csc_str}")
    list(LENGTH _csc_matches _csc_length)
    set(${_csc_return} ${_csc_length} PARENT_SCOPE)
endfunction()
