include_guard()

include(cache/cache_tarball)
function(_cpp_cache_source _ccs_path _ccs_cache _ccs_name _ccs_version)
    _cpp_cache_source_path(
        _ccs_src_path ${_ccs_cache} ${_ccs_name} "${_ccs_version}"
    )
    _cpp_does_not_exist(_ccs_src_dne ${_ccs_src_path})
    if(_ccs_src_dne)
        _cpp_error(
            "Source for dependency ${_ccs_name} does not exist. "
            "Troubleshooting: Have you called _cpp_cache_build_dependency?"
        )
    endif()
    set(${_ccs_path} ${_ccs_src_path} PARENT_SCOPE)
endfunction()


function(_cpp_cache_add_source _ccas_cache _ccas_name _ccas_version)
    _cpp_cache_tarball(
       _ccas_tar ${_ccas_cache} ${_ccas_name} "${_ccas_version}"
    )
    _cpp_cache_source_path(
        _ccas_src_path ${_ccas_cache} ${_ccas_name} "${_ccas_version}"
    )

    #Untarring and copying is quick so we don't worry about memoization
    _cpp_exists(_ccas_have_src ${_ccas_src_path})
    if(_ccas_have_src)
        file(REMOVE_RECURSE ${_ccas_src_path})
    endif()

    _cpp_untar_directory(${_ccas_tar} ${_ccas_src_path})
endfunction()
