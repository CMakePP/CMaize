include(find_recipe/find_from_config/find_from_config)
include(find_recipe/find_from_module/find_from_module)
include(utility/set_return)

function(_cpp_FindRecipe_factory _cFf_handle)
    cpp_parse_arguments(
        _cFf "${ARGN}"
        OPTIONS NAME VERSION FIND_MODULE
        LISTS COMPONENTS
        MUST_SET NAME
    )
    _cpp_is_not_empty(_cFf_has_module _cFf_FIND_MODULE)
    if(_cFf_has_module)
        _cpp_FindFromModule_ctor(
           _cFf_temp
           "${_cFf_FIND_MODULE}"
           "${_cFf_NAME}"
           "${_cFf_VERSION}"
           "${_cFf_COMPONENTS}"
        )
    else()
        _cpp_FindFromConfig_ctor(
            _cFf_temp
            "${_cFf_NAME}"
            "${_cFf_VERSION}"
            "${_cFf_COMPONENTS}"
        )
    endif()
    _cpp_set_return(${_cFf_handle} ${_cFf_temp})
endfunction()
