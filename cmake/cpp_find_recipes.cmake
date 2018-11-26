function(_cpp_find_from_config _cffc_return _cffc_name _cffc_ver _cffc_comps)
    #This only honors CMAKE_PREFIX_PATH and whatever paths were provided
set(${_cffc_return}
"macro(_cpp_call_recipe _ccr_path)
    find_package(
        ${_cffc_name}
        ${_cffc_ver}
        ${_cffc_comps}
        CONFIG
        QUIET
        PATHS \"\${_ccr_path}\"
        NO_PACKAGE_ROOT_PATH
        NO_SYSTEM_ENVIRONMENT_PATH
        NO_CMAKE_PACKAGE_REGISTRY
        NO_CMAKE_SYSTEM_PATH
        NO_CMAKE_SYSTEM_PACKAGE_REGISTRY
    )
endmacro()" PARENT_SCOPE)
endfunction()


function(_cpp_find_from_module _cffm_return _cffm_module_dir _cffm_name
                               _cffm_version _cffm_comps)
    set(${_cffm_return}
"macro(_cpp_call_recipe _ccr_path)
list(APPEND CMAKE_MODULE_PATH ${_cffm_module_dir})
list(APPEND CMAKE_PREFIX_PATH \"\${_ccr_path}\")
find_package(
    ${_cffm_name}
    ${_cffm_version}
    ${_cffm_comps}
    MODULE
    QUIET
)
endmacro()" PARENT_SCOPE)
endfunction()

function(_cpp_find_recipe_dispatch _cfrd_dest _cfrd_name _cfrd_version
                                   _cfrd_comps _cfrd_recipe)
    if(_cfrd_recipe)
        get_filename_component(_cfrd_module_dir ${_cfrd_recipe} DIRECTORY)
        _cpp_find_from_module(
            _cfrd_contents
            "${_cfrd_module_dir}"
            "${_cfrd_name}"
            "${_cfrd_version}"
            "${_cfrd_comps}"
        )
    else()
        _cpp_find_from_config(
            _cfrd_contents
            "${_cfrd_name}"
            "${_cfrd_version}"
            "${_cfrd_comps}"
        )
    endif()
    file(WRITE ${_cfrd_dest} ${_cfrd_contents})
endfunction()
