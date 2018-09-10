function(_cpp_debug_print _cdp_msg)
    if(CPP_DEBUG_MODE)
        message("CPP DEBUG: ${_cdp_msg}")
    endif()
endfunction()


