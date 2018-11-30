include_guard()
include(dependency/cpp_find_package)

function(_cpp_special_find _csf_was_found _csf_cache _csf_name _csf_version
                           _csf_comps)
    string(TOUPPER "${_csf_name}" _csf_uc_name)
    string(TOLOWER "${_csf_name}" _csf_lc_name)
    set(${_csf_was_found} FALSE)
    foreach(_csf_case ${_csf_name} ${_csf_uc_name} ${_csf_lc_name})
        foreach(_csf_suffix _DIR _ROOT)
            set(_csf_var ${_csf_case}${_csf_suffix})
            #Did the user set this variable
            _cpp_is_not_empty(_csf_set ${_csf_var})
            if(_csf_set)
                set(_csf_value ${${_csf_var}})
                _cpp_debug_print(
                        "Looking for ${_csf_name} with ${_csf_var}=${_csf_value}"
                )
                _cpp_find_package(
                        _csf_found ${_csf_cache} ${_csf_name} "${_csf_version}"
                                   "${_csf_comps}" ${_csf_value}
                )
                if(NOT _csf_found)
                    _cpp_error(
                            "${_csf_var} set, but ${_csf_name} not found there"
                            "Troubleshooting:"
                            "  Is ${_csf_name} installed to ${_csf_value}?"
                    )
                endif()
                set(${_csf_was_found} TRUE)
                break()
            endif()
        endforeach()
        if(${_csf_was_found})
            break()
        endif()
    endforeach()
    set(${_csf_was_found} ${${_csf_was_found}} PARENT_SCOPE)
endfunction()
