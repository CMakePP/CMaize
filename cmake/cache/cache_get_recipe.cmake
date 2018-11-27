include_guard()

function(_cpp_cache_get_recipe_path _ccgrp_path _ccgrp_cache _ccgrp_name)
    set(
        ${_ccgrp_path}
        ${_ccgrp_cache}/get_recipes/get-${_ccgrp_name}.cmake
        PARENT_SCOPE
    )
endfunction()

function(_cpp_cache_get_recipe _cchr_recipe _cchr_cache _cchr_name)
    _cpp_cache_get_recipe_path(${_cchr_recipe} ${_cchr_cache} ${_cchr_name})
    set(_cchr_value ${${_cchr_recipe}})
    _cpp_does_not_exist(_cchr_dne ${_cchr_value})
    if(_cchr_dne)
        _cpp_error(
            "Get recipe ${_cchr_value} does not exist. "
            "Troubleshooting: Did you call _cpp_cache_add_dependency?"
        )
    else()
        set(${_cchr_recipe} ${${_cchr_recipe}} PARENT_SCOPE)
    endif()
endfunction()

function(_cpp_cache_add_get_recipe _ccagr_cache _ccagr_name _ccagr_contents)
    _cpp_cache_get_recipe_path(_ccagr_recipe ${_ccagr_cache} ${_ccagr_name})
    _cpp_exists(_ccagr_already_present ${_ccagr_recipe})
    if(_ccagr_already_present)
        file(WRITE ${_ccagr_recipe}.temp "${_ccagr_contents}")
        file(SHA1 ${_ccagr_recipe} _ccagr_old_hash)
        file(SHA1 ${_ccagr_recipe}.temp   _ccagr_new_hash)
        _cpp_are_not_equal(
           _ccagr_different_files ${_ccagr_old_hash} ${_ccagr_new_hash}
        )
        if(_ccagr_different_files)
            _cpp_error(
                "Get recipe ${_ccagr_recipe} already exists and is different"
                " than new get recipe. Troubleshooting: Did you change the "
                "origin of ${_ccagr_name}?"
            )
        endif()
    else()
        file(WRITE ${_ccagr_recipe} "${_ccagr_contents}")
    endif()
endfunction()
