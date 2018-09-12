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
    string(COMPARE EQUAL "${${_cie_input}}" "" _cie_empty)
    set(${_cie_return} ${_cie_empty} PARENT_SCOPE)
endfunction()

function(_cpp_non_empty _cne_return _cne_input)
    string(COMPARE NOTEQUAL "${${_cne_input}}" "" _cne_empty)
    set(${_cne_return} ${_cne_empty} PARENT_SCOPE)
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
