include(cpp_checks)

function(_cpp_debug_print _cdp_msg)
    if(CPP_DEBUG_MODE)
        message("CPP DEBUG: ${_cdp_msg}")
    endif()
endfunction()


function(_cpp_print_target _cpt_name)
    message("Target : ${_cpt_name}")
    set(_cpt_props SOURCES COMPILE_FEATURES LINK_LIBRARIES PUBLIC_HEADER
                   LINK_FLAGS INCLUDE_DIRECTORIES
    )
    foreach(_cpt_prop ${_cpt_props})
        get_property(
            _cpt_value
            TARGET ${_cpt_name}
            PROPERTY ${_cpt_prop}
        )
        _cpp_non_empty(_cpt_has_prop _cpt_value)
        if(_cpt_has_prop)
            message("${_cpt_prop} : ${_cpt_value}")
        endif()
    endforeach()
endfunction()

function(_cpp_print_interface _cpt_name)
    message("Target : ${_cpt_name}")
    set(_cpt_props SOURCES COMPILE_FEATURES LINK_LIBRARIES INCLUDE_DIRECTORIES)
    foreach(_cpt_prop ${_cpt_props})
        get_property(
                _cpt_value
                TARGET ${_cpt_name}
                PROPERTY INTERFACE_${_cpt_prop}
        )
        _cpp_non_empty(_cpt_has_prop _cpt_value)
        if(_cpt_has_prop)
            message("${_cpt_prop} : ${_cpt_value}")
        endif()
    endforeach()
endfunction()
