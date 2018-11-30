include_guard()
include(recipes/cpp_get_recipe_dispatch)
include(cache/cache_get_recipe)
include(recipes/cpp_find_recipe_dispatch)
include(cache/cache_find_recipe)
include(recipes/cpp_build_recipe_dispatch)
include(cache/cache_build_recipe)

function(_cpp_cache_add_dependency _ccad_cache _ccad_name)
    #Note it's possible for version to be empty
    _cpp_get_recipe_dispatch(_ccad_get_contents ${ARGN})

    _cpp_cache_add_get_recipe(
        ${_ccad_cache} ${_ccad_name} "${_ccad_get_contents}"
    )

    _cpp_find_recipe_dispatch(
        _ccad_find_contents ${_ccad_cache} ${_ccad_name} ${ARGN}
    )

    _cpp_cache_add_find_recipe(
            ${_ccad_cache} ${_ccad_name} "${_ccad_find_contents}"
    )

    _cpp_build_recipe_dispatch(_ccad_build_conts ${ARGN})

    _cpp_cache_add_build_recipe(
            ${_ccad_cache} ${_ccad_name} "${_ccad_build_conts}"
    )
endfunction()
