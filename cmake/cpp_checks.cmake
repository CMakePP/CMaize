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

function(_cpp_assert_true _cat_variable)
    set(_cat_value ${${_cat_variable}})
    if("${_cat_value}" STREQUAL "TRUE")
    elseif(NOT ${_cat_value})
        message(FATAL_ERROR "${_cat_variable} is FALSE")
    endif()
endfunction()

function(_cpp_assert_false _caf_variable)
    set(_caf_value ${${_caf_variable}})
    if("${_caf_value}" STREQUAL "FALSE")
    elseif(${_caf_variable})
        message(FATAL_ERROR "${_caf_variable} is TRUE")
    endif()
endfunction()

function(_cpp_assert_str_equal _case_lhs _case_rhs)
    if(NOT "${_case_lhs}" STREQUAL "${_case_rhs}")
        message(FATAL_ERROR "\"${_case_lhs}\" != \"${_case_rhs}\"")
    endif()
endfunction()

function(_cpp_assert_str_not_equal _casne_lhs _casne_rhs)
    if("${_casne_lhs}" STREQUAL "${_casne_rhs}")
        message(FATAL_ERROR "\"${_casne_lhs}\" == \"${_casne_rhs}\"")
    endif()
endfunction()


function(_cpp_assert_cpp_main_called)
    foreach(_cacmc_var CPP_SRC_DIR CPP_project_name CPP_LIBDIR CPP_BINDIR
                       CPP_INCDIR CPP_SHAREDIR)
        _cpp_valid(_cacmc_valid ${_cacmc_var})
        if(NOT ${_cacmc_valid})
            message(
                FATAL_ERROR
                "${_cacmc_var} is not set.  Did you call CPPMain()?"
            )
        endif()
    endforeach()
endfunction()
