include_guard()
include(cache/cache_find_module)

function(_cpp_update_find_header _cufh_header _cufh_cache _cufh_name)
    _cpp_cache_find_module(_cufh_recipe ${_cufh_cache} ${_cufh_name})
    get_filename_component(_cufh_dir ${_cufh_recipe} DIRECTORY)
    set(_cufh_mod_path "list(APPEND CMAKE_MODULE_PATH ${_cufh_dir})")
    set(_cufh_orig_header "${${_cufh_header}}")
    set(_cufh_contents "${_cufh_orig_header}\n    ${_cufh_mod_path}")
    set(${_cufh_header} "${_cufh_contents}" PARENT_SCOPE)
endfunction()

function(_cpp_find_recipe_dispatch _cfrd_contents _cfrd_cache _cfrd_name)
    cpp_parse_arguments(_cfrd "${ARGN}" OPTIONS FIND_MODULE)

    #We use a macro b/c we're wrapping find_package which introduces variables
    set(_cfrd_start "macro(_cpp_find_recipe _cfr_version _cfr_comps _cfr_path)")
    set(_cfrd_end "endmacro()")
    #These are the args that get passed to _cpp_find_from_XXX, factored out
    set(_cfrd_args "\"\${_cfr_version}\" \"\${_cfr_comps}\" \"\${_cfr_path}\"")

    _cpp_is_not_empty(_cfrd_have_module _cfrd_FIND_MODULE)
    if(_cfrd_have_module)
        _cpp_cache_add_find_module(
            ${_cfrd_cache} ${_cfrd_name} ${_cfrd_FIND_MODULE}
        )
        _cpp_update_find_header(_cfrd_start ${_cfrd_cache} ${_cfrd_name})
        set(_cfrd_include "include(recipes/cpp_find_from_module)")
        set(_cfrd_body "_cpp_find_from_module(${_cfrd_name} ${_cfrd_args})")
    else()
        set(_cfrd_include "include(recieps/cpp_find_from_config)")
        set(_cfrd_body "_cpp_find_from_config(${_cfrd_name} ${_cfrd_args})")
    endif()
    set(
        ${_cfd_contents}
        "${_cfrd_start}\n${_cfrd_include}\n${_cfrd_body}\n${_cfrd_footer}"
        PARENT_SCOPE
    )
endfunction()
