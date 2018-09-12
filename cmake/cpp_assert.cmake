function(_cpp_assert_true _cat_variable)
    if(${_cat_variable})
    else()
        message(
            FATAL_ERROR
            "${_cat_variable} is set to false value: ${${_cat_variable}}"
        )
    endif()
endfunction()

function(_cpp_assert_false _caf_variable)
    if(${_caf_variable})
        message(
            FATAL_ERROR
            "${_caf_variable} is set true value: ${${_caf_variable}}"
        )
    endif()
endfunction()

function(_cpp_assert_equal _cae_lhs _cae_rhs)
    string(COMPARE NOTEQUAL "${_cae_lhs}" "${_cae_rhs}" _cae_result)
    if(_cae_result)
        message(
            FATAL_ERROR
            "LHS != RHS\nLHS : ${_cae_lhs}\nRHS : ${_cae_rhs}"
        )
    endif()
endfunction()

function(_cpp_assert_not_equal _cane_lhs _cane_rhs)
    string(COMPARE EQUAL "${_cane_lhs}" "${_cane_rhs}" _cane_result)
    if(_cane_result)
        message(
            FATAL_ERROR
            "LHS == RHS\nLHS : ${_cane_lhs}\nRHS : ${_cane_rhs}"
        )
    endif()
endfunction()

function(_cpp_assert_exists _cae_path)
    if(EXISTS ${_cae_path})
    else()
        message(
            FATAL_ERROR
            "No such file or directory: ${_cae_path}"
        )
    endif()
endfunction()

function(_cpp_assert_does_not_exist _cadne_path)
    if(EXISTS ${_cadne_path})
        message(
            FATAL_ERROR
            "File or directory exists: ${_cadne_path}"
        )
    endif()
endfunction()
