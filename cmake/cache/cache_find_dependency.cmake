include_guard()

include(cache/cache_paths)
function(_cpp_cache_find_dependency _ccfd_found _ccfd_cache _ccfd_name
                                    _ccfd_version _ccfd_comps)
    set(${_ccfd_found} FALSE PARENT_SCOPE) #Will change if we do find it
    _cpp_cache_get_recipe_path(_ccfd_get)
endfunction()
