include_guard()

#Pulled this function out to avoid contaminating the namespace
function(_cpp_check_for_module _ccfm_name)
    find_file(
        _ccfm_found
        "Find${_ccfm_name}.cmake"
        PATHS ${CMAKE_MODULE_PATH}
     #   NO_DEFAULT_PATH
    )
    _cpp_contains(_ccfm_module_not_found "NOTFOUND" "${_ccfm_found}")
    if(_ccfm_module_not_found)
        _cpp_error(
            "Find${_ccfm_name}.cmake was not found in CMAKE_MODULE_PATH."
            "CMAKE_MODULE_PATH=${CMAKE_MODULE_PATH}."
        )
    endif()
endfunction()

macro(_cpp_find_from_module _cffm_name _cffm_version _cffm_comps _cffm_path)
    _cpp_check_for_module(${_cffm_name})
    list(APPEND CMAKE_PREFIX_PATH ${_cffm_path})
    find_package(${_cffm_name} ${_cffm_version} ${_cffm_comps} MODULE QUIET)
endmacro()
