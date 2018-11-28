include_guard()
include(cache/cache_sanitize_version)

function(_cpp_cache_get_recipe_path _ccgrp_path _ccgrp_cache _ccgrp_name)
    set(
        ${_ccgrp_path}
        ${_ccgrp_cache}/get_recipes/get-${_ccgrp_name}.cmake
        PARENT_SCOPE
    )
endfunction()

function(_cpp_cache_tarball_path _cctp_output _cctp_cache _cctp_name _cctp_ver)
    _cpp_cache_sanitize_version(_cctp_eff_ver "${_cctp_ver}")
    #Return the result
    set(
        ${_cctp_output}
        ${_cctp_cache}/${_cctp_name}/${_cctp_name}.${_cctp_eff_ver}.tar.gz
        PARENT_SCOPE
    )
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

function(_cpp_cache_find_module_path _ccfmp_path _ccfmp_cache _ccfmp_name)
    set(
        ${_ccfmp_path}
        ${_ccfmp_cache}/find_recipes/modules/Find${_ccfmp_name}.cmake
        PARENT_SCOPE
    )
endfunction()

function(_cpp_cache_build_recipe_path _ccbrp_output _ccbrp_cache _ccbrp_name
         _ccbrp_version)
    _cpp_cache_sanitize_version(_ccbrp_eff_ver "${_ccbrp_version}")
    set(_ccbrp_filename build-${_ccbrp_name}.${_ccbrp_eff_ver}.cmake)
    set(
            ${_ccbrp_output}
            ${_ccbrp_cache}/build_recipes/${_ccbrp_filename}
            PARENT_SCOPE
    )
endfunction()
