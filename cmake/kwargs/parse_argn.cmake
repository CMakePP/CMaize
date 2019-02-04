include_guard()
include(object/object)
include(kwargs/set_kwarg)

function(_cpp_kwargs_parse_argn _cKpa_handle)
    _cpp_Object_get_value(${_cKpa_handle} _cKpa_toggles toggles)
    _cpp_Object_get_value(${_cKpa_handle} _cKpa_options options)
    _cpp_Object_get_value(${_cKpa_handle} _cKpa_lists lists)
    cmake_parse_arguments(
        _cKpa "${_cKpa_toggles}" "${_cKpa_options}" "${_cKpa_lists}" ${ARGN}
    )

    foreach(_cKpa_category toggles options lists)
        foreach(_cKpa_option_i ${_cKpa_${_cKpa_category}})
            set(_cKpa_value "${_cKpa_${_cKpa_option_i}}")
            _cpp_is_empty(_cKpa_empty _cKpa_value)
            if(_cKpa_empty)
                continue()
            endif()
            _cpp_Kwargs_set_kwarg(
                ${_cKpa_handle} ${_cKpa_option_i} "${_cKpa_value}"
            )
        endforeach()
    endforeach()
    _cpp_Object_set_value(
        ${_cKpa_handle} unparsed "${_cKpa_UNPARSED_ARGUMENTS}"
    )
endfunction()
