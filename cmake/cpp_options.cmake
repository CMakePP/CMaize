include(cpp_checks) #For _cpp_valid
include(cpp_print) #For _cpp_debug_print

function(cpp_option _cpo_opt _cpo_default)
    _cpp_valid(_cpo_valid ${_cpo_opt})
    if(_cpo_valid)
        _cpp_debug_print("${_cpo_opt} set by user to: ${${_cpo_opt}}")
    else()
        set(${_cpo_opt} ${_cpo_default} PARENT_SCOPE)
        _cpp_debug_print("${_cpo_opt} set to default: ${_cpo_default}")
    endif()
endfunction()
