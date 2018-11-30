include_guard()
include(cache/cache_paths)
include(cache/cache_tarball)
include(cache/cache_source)
function(_cpp_cache_build_dependency _ccbd_cache _ccbd_name _ccbd_version
                                     _ccbd_tc)

    _cpp_cache_add_tarball(${_ccbd_cache} ${_ccbd_name} "${_ccbd_version}")
    _cpp_cache_add_source(${_ccbd_cache} ${_ccbd_name} "${_ccbd_version}")

    _cpp_cache_install_path(
            _ccbd_install ${_ccbd_cache} ${_ccbd_name} "${_ccbd_version}"
            ${_ccbd_tc}
    )
    _cpp_cache_source(
        _ccbd_src ${_ccbd_cache} ${_ccbd_name} "${_ccbd_version}"
    )
    _cpp_exists(_ccbd_already_built ${_ccbd_install})
    if(_ccbd_already_built)
        return()
    endif()
    _cpp_cache_build_recipe(_ccbd_build ${_ccbd_cache} ${_ccbd_name})
    include(${_ccbd_build})
    _cpp_build_recipe(${_ccbd_install} ${_ccbd_src} ${_ccbd_tc})
endfunction()
