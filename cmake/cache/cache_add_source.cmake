include_guard()

function(_cpp_cache_add_source _ccas_src _ccas_cache _ccas_name _ccas_version)

    #Get the path for the tarball (note it's possible for version to be empty)
    _cpp_cache_add_tar_path(
        _ccas_tar_name ${_ccas_cache} ${_ccas_name} "${_ccas_version}"
    )

    #Add the tarball to the cache
    _cpp_cache_add_tarball(${_ccas_tar_name} "${_ccas_version}"
                           ${_ccas_get_recipe}
    )

    _cpp_cache_source_path(
        _ccas_src_path ${_ccas_cache} ${_ccas_name} "${_ccas_version}"
    )

    _cpp_exists(_ccas_have_src ${_ccas_src_path})
    if(_ccas_have_src)
        return()
    endif()

    _cpp_untar_directory(${_ccas_tar_name} ${_ccas_src_path})
endfunction()
