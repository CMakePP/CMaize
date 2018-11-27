include_guard()

function(_cpp_cache_build_recipe_path _ccbrp_output _ccbrp_cache _ccbrp_name
                                _ccbrp_version)
    set(_ccbrp_filename build-${_ccbrp_name}.${_ccbrp_version}.cmake)
    set(
        ${_ccbrp_output}
        ${_ccbrp_cache}/build_recipes/${_ccbrp_filename}
        PARENT_SCOPE
    )
endfunction()

function(_cpp_cache_build_recipe _ccbr_recipe _ccbr_cache _ccbr_name
                                 _ccbr_version)
    _cpp_cache_build_recipe_path(_ccbr_recipe_path ${_ccbr_cache} ${_ccbr_name}
                                                   "${_ccbr_version}")
    _cpp_does_not_exist(_ccbr_dne ${_ccbr_recipe_path})
    if(_ccbr_dne)
        _cpp_error(
            "Build recipe ${_ccbr_recipe_path} does not exist. "
            "Troubleshooting: Did you call _cpp_cache_add_dependency?"
        )
    else()
        set(${_ccbr_recipe} ${_ccbr_recipe_path} PARENT_SCOPE)
    endif()
endfunction()

function(_cpp_cache_add_build_recipe _ccabr_cache _ccabr_name _ccabr_version
                                     _ccabr_contents)
    _cpp_build_recipe_path(
      _ccabr_recipe ${_ccabr_cache} ${_ccabr_name} "${_ccabr_version}"
    )
    _cpp_exists(_ccabr_already_present ${_ccabr_recipe})
    if(_ccabr_already_present)
        file(WRITE ${_ccabr_recipe}.temp "${_ccabr_contents}")
        file(SHA1 ${_ccabr_recipe} _ccabr_old_hash)
        file(SHA1 ${_ccabr_recipe}.temp   _ccabr_new_hash)
        _cpp_are_not_equal(
            _ccabr_different_files ${_ccabr_old_hash} ${_ccabr_new_hash}
        )
        if(_ccabr_different_files)
            _cpp_error(
                "Build recipe ${_ccabr_recipe} already exists and is different"
                " than new build recipe. Troubleshooting: Has the dependency's"
                " build system changed?"
            )
        endif()
    else()
        file(WRITE ${_ccabr_recipe} "${_ccabr_contents}")
    endif()
endfunction()
