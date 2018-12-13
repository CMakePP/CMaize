include_guard()

## Function for processing the ``<Name>_FOUND`` variable of ``find_package``
#
# CMake's ``find_package`` function returns the result via ``<Name>_FOUND``
# variable. While convention is that the capitalization of the package's name
# in the variable matches the capitialization used to call ``find_package``,
# particularly when ``find_package`` is used in "module" mode, this is not
# always the case. This function will loop over possible capitalizations in an
# attempt to better ensure we find the results of ``find_package``.
#
# :param name: The name of the package whose found status is in question.
#
# :CMake Variables:
#
#     * *<Name>_FOUND* - Here ``<Name>`` matches the input capitalization. This
#       variable will be considered as one possible output of ``find_package``.
#     * *<NAME>_FOUND* - Here ``<NAME>`` is the name in all uppercase letters.
#       This variable will be considered as one possible output of
#       ``find_package``.
#     * *<name>_FOUND* - Here ``<name>`` is the name in all lowercase letters.
#       This variable will be considered as one possible output of
#       ``find_package``.
function(_cpp_handle_found_var _chfv_found _chfv_name)
    #Make the capitialization variations
    string(TOUPPER ${_chfv_name} _chfv_uc_name)
    string(TOLOWER ${_chfv_name} _chfv_lc_name)
    set(_chfv_was_found FALSE)
    foreach(_chfv_var ${_chfv_name} ${_chfv_uc_name} ${_chfv_lc_name})
        if("${${_chfv_var}_FOUND}")
            set(_chfv_was_found TRUE)
            break()
        endif()
    endforeach()
    set(${_chfv_found} ${_chfv_was_found} PARENT_SCOPE)
endfunction()
