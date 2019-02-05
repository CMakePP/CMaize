include_guard()
include(build_recipe/build_recipe)
include(get_recipe/get_recipe)
include(kwargs/kwargs)
include(user_api/find_dependency_add_kwargs)

function(_cpp_find_or_build_dependency_add_kwargs _cfobdak_kwargs)
    _cpp_GetRecipe_factory_add_kwargs(${_cfobdak_kwargs})
    _cpp_find_dependency_add_kwargs(${_cfobdak_kwargs})
    _cpp_BuildRecipe_factory_add_kwargs(${_cfobdak_kwargs})
    _cpp_Kwargs_add_keywords(
        ${_cfobdak_kwargs}
        OPTIONS CPP_CACHE BINARY_DIR
        LISTS DEPENDS
    )
    _cpp_Kwargs_set_default(${_cfobdak_kwargs} CPP_CACHE "${CPP_INSTALL_CACHE}")
    _cpp_Kwargs_set_default(${_cfobdak_kwargs} BINARY_DIR "${CMAKE_BINARY_DIR}")
endfunction()
