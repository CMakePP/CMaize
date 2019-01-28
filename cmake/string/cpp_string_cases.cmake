include_guard()
include(utility/set_return)


## Generates common case-variants of a string
#
# CMake is unfortunately case-sensitive while relying on a string-based variable
# system. This means that many of CMake's built-in functions have no tolerance
# when it comes to the case of the strings the user provides. This function
# will take a user's input and generate all common case variants of it, which at
# the moment includes: input case, uppercase, and lowercase.
#
# :param return: An identifier to hold the list of common variants.
# :param input: The string we want common cases of.
function(_cpp_string_cases _csc_return _csc_input)
    set(_csc_rv "${_csc_input}")

    #All lowercase
    string(TOLOWER "${_csc_input}" _csc_lc)
    _cpp_are_not_equal(_csc_add_case "${_csc_input}" "${_csc_lc}")
    if(_csc_add_case)
        list(APPEND _csc_rv "${_csc_lc}")
    endif()

    #All capitals
    string(TOUPPER "${_csc_input}" _csc_uc)
    _cpp_are_not_equal(_csc_add_case "${_csc_input}" "${_csc_uc}")
    if(_csc_add_case)
        list(APPEND _csc_rv "${_csc_uc}")
    endif()

    _cpp_set_return(${_csc_return} "${_csc_rv}")
endfunction()
