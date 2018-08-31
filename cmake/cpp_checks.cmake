# Functions for testing the state of a variable

#Note: Use False=0 and True=1 not FALSE/OFF/TRUE/ON otherwise if statements
#won't recognize the return's contents as boolean without a CMake policy being
#set.

function(_cpp_is_defined _cid_return _cid_input)
    if(DEFINED ${_cid_input})
        set(${_cid_return} 1 PARENT_SCOPE)
    else()
        set(${_cid_return} 0 PARENT_SCOPE)
    endif()
endfunction()

function(_cpp_is_empty _cie_return _cie_input)
    if("${${_cie_input}}" STREQUAL "")
        set(${_cie_return} 1 PARENT_SCOPE)
    else()
        set(${_cie_return} 0 PARENT_SCOPE)
    endif()
endfunction()

function(_cpp_valid _cv_return _cv_input)
    _cpp_is_defined(_cv_def ${_cv_input})
    if(_cv_def)
        _cpp_is_empty(_cv_empty ${_cv_input})
        #Setting it to (NOT _cv_empty) doesn't seem to work
        if(_cv_empty)
            set(${_cv_return} 0 PARENT_SCOPE)
        else()
            set(${_cv_return} 1 PARENT_SCOPE)
        endif()
    else() #Not defined
        set(${_cv_return} 0 PARENT_SCOPE)
    endif()
endfunction()
