include_guard()

## Determines if a substring appears in a particular string.
#
# :param return: True if the substring is present and false otherwise.
# :param substring: The substring we are looking for.
# :param string: The string we are searching for the substring in.
function(_cpp_contains _cc_return _cc_substring _cc_string)
    string(FIND "${_cc_string}" "${_cc_substring}" _cc_pos)
    if("${_cc_pos}" STREQUAL "-1")
        set(${_cc_return} 0 PARENT_SCOPE)
    else()
        set(${_cc_return} 1 PARENT_SCOPE)
    endif()
endfunction()
