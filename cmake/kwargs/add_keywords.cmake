include_guard()
include(object/object)
include(logic/in_list)
include(kwargs/kwarg_value)

## Member for adding keywords to a kwargs object
#
# :param handle: A handle to an already existing Kwargs instance.
#
# :kwargs:
#
#   * *TOGGLES* - A list of keywords to treat a toggles
#   * *OPTIONS* - A list of keywords to treat as options
#   * *LISTS*   - A list of keywords to treat as lists
function(_cpp_Kwargs_add_keywords _cKak_handle)
    set(_cKak_M_kwargs TOGGLES OPTIONS LISTS)
    cmake_parse_arguments(_cKak "" "" "${_cKak_M_kwargs}" ${ARGN})

    set(_cKak_default FALSE)        
    foreach(_cKak_type ${_cKak_M_kwargs})
        string(TOLOWER "${_cKak_type}" _cKak_lc)
        _cpp_Object_get_value(${_cKak_handle} _cKak_keywords ${_cKak_lc})
        foreach(_cKak_key ${_cKak_${_cKak_type}})
            _cpp_in_list(_cKak_already_there ${_cKak_key} _cKak_keywords)
            if(_cKak_already_there)
                continue()
            endif()
            _cpp_Object_add_members(${_cKak_handle} kwargs_${_cKak_key})
            _cpp_Kwargs_set_kwarg(
                ${_cKak_handle} ${_cKak_key} "${_cKak_default}"
            )
            list(APPEND _cKak_keywords ${_cKak_key})
        endforeach()
        _cpp_Object_set_value(${_cKak_handle} ${_cKak_lc} "${_cKak_keywords}")
        set(_cKak_default "")
    endforeach()        
endfunction()

