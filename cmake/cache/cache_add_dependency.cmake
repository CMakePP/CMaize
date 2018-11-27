include_guard()
include(cache/cache_get_recipe)
include(cache/cache_add_source)

function(_cpp_cache_add_dependency _ccad_cache _ccad_name _ccad_version)
    #Note it's possible for version to be empty

    #Adds the get and find recipes to the cache
    _cpp_get_recipe_dispatch(_ccad_get_contents ${ARGN})

    _cpp_cache_add_get_recipe(
        ${_ccad_cache} ${_ccad_name} "${_ccad_get_contents}"
    )

    _cpp_find_recipe_dispatch(_ccad_find_contents ${_ccad_cache} ${_ccad_name})

    _cpp_cache_add_find_recipe(
            ${_ccad_cache} ${_ccad_name} "${_ccad_find_contents}"
    )

    #Now add build recipe (requires inspecting the source to determine the build
    #system generator
    _cpp_cache_get_recipe(_ccad_get_recipe ${_ccad_cache} ${_ccad_name})

    _cpp_cache_add_source(
        ${_ccad_cache} ${_ccad_name} "${_ccad_version}" ${_ccad_get_recipe}
    )

    _cpp_cache_source_path(
        _ccad_src ${_ccad_cache} ${_ccad_name} "${_ccad_version}"
    )

    _cpp_build_recipe_dispatch(_ccad_build_conts ${_ccad_src} ${ARGN})

    _cpp_cache_add_build_recipe(
        ${_ccad_cache} ${_ccad_name} "${_ccad_version}" "${_ccad_build_conts}"
    )
endfunction()

