function(_cpp_find_from_config _cffc_return _cffc_name)
    #This only honors CMAKE_PREFIX_PATH and whatever paths were provided
set(${_cffc_return}
"find_package(
    ${_cffc_name}
    \${_cfr_version}
    \${_cfr_comps}
    CONFIG
    QUIET
    PATHS \"\${_cfr_path}\"
    NO_PACKAGE_ROOT_PATH
    NO_SYSTEM_ENVIRONMENT_PATH
    NO_CMAKE_PACKAGE_REGISTRY
    NO_CMAKE_SYSTEM_PATH
    NO_CMAKE_SYSTEM_PACKAGE_REGISTRY
)" PARENT_SCOPE)
endfunction()


function(_cpp_find_from_module _cffm_return _cffm_name)
    set(${_cffm_return}
"list(APPEND CMAKE_PREFIX_PATH \"\${_cfr_path}\")
find_package(
    ${_cffm_name}
    \${_cfr_version}
    \${_cfr_comps}
    MODULE
    QUIET
)
endmacro()" PARENT_SCOPE)
endfunction()

#This function copies the module to the cache and hard code its path into the
#recipe, it's code factorization to make find_recipe_dispatch easier to read
#and really isn't intended to be used from anywhere, but there
function(_cpp_update_header _cuh_header _cuh_cache _cuh_name _cuh_module)
    set(_cuh_path ${_cuh_cache}/find_recipes/modules)
    configure_file(${_cuh_module} ${_cuh_path}/Find${_cuh_name}.cmake COPYONLY)
    set(_cuh_mod_path "list(APPEND CMAKE_MODULE_PATH ${_cuh_path})")
    set(
        ${_cuh_header}
        "${${_cuh_header}}\n    ${_cuh_mod_path}"
        PARENT_SCOPE
    )
endfunction()

function(_cpp_find_recipe_dispatch _cfrd_contents _cfrd_cache _cfrd_name)
    #Note it's possible for version to be empty
    cpp_parse_arguments(_cfrd "${ARGN}" OPTIONS FIND_MODULE)

    #We use a macro b/c we're wrapping find_package which introduces variables
    set(
        _cfrd_header "macro(_cpp_find_recipe _cfr_version _cfr_comps _cfr_path)"
    )
    set(_cfrd_footer "endmacro()")

    _cpp_is_not_empty(_cfrd_have_module _cfrd_FIND_MODULE)
    if(_cfrd_have_module)
        _cpp_update_header(
            _cfrd_header _cfrd_cache _cfrd_name _cfrd_FIND_MODULE
        )
        _cpp_find_from_module(_cfrd_body ${_cfrd_name})
    else()
        _cpp_find_from_config(_cfrd_body ${_cfrd_name})
    endif()
    set(${_cfd_contents} "${_cfrd_header}${_cfrd_body}${_cfrd_footer}")
endfunction()
