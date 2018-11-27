include_guard()

function(_cpp_cache_tarball_path _cctp_file _cctp_cache _cctp_name
                                 _cctp_version)

    #If we don't have a version assume user wants the "latest"
    _cpp_is_empty(_cctp_no_ver _cctp_version)
    if(_cctp_no_ver)
        set(_cctp_eff_ver "latest")
    else()
        set(_cctp_eff_ver ${_cctp_version})
    endif()

    #Return the result
    set(
        ${_cctp_file}
        ${_cctp_cache}/${_cctp_name}/${_cctp_name}.${_cctp_eff_ver}.tar.gz
        PARENT_SCOPE
    )
endfunction()

function(_cpp_cache_add_tarball _ccat_tar_name _ccat_version _ccat_get_recipe)

    #If we were given a version see if we already have the tarball
    _cpp_is_not_empty(_ccat_have_ver _ccat_version)
    if(_ccat_have_ver)
        _cpp_exists(_ccat_have_tar ${_ccat_tar_name})
        if(_ccat_have_tar)
            return()
        endif()
    endif()

    #We don't (or we don't have a version) so grab the tarball
    include(${_ccat_get_recipe})
    _cpp_get_recipe(${_ccat_tar_name} "${_ccat_version}")
endfunction()

function(_cpp_cache_source_path _ccsp_path _ccsp_cache _ccsp_name _ccsp_version)
    _cpp_cache_tarball_path(
        _ccsp_tar_path ${_ccsp_cache} ${ccsp_name} ${_ccsp_version}
    )
    file(SHA1 ${_ccsp_tar_path} _ccsp_src_hash)
    set(
        ${_ccsp_path}
        ${_ccsp_cache}/${_ccsp_name}/${_ccsp_src_hash}/source PARENT_SCOPE)
endfunction()

function(_cpp_cache_add_source _ccas_cache _ccas_name _ccas_version
                               _ccas_get_recipe)
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
