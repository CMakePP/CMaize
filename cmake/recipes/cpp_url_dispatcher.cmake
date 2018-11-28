include_guard()

function(_cpp_url_dispatcher _cud_contents _cud_url)
    #At the moment we know how to parse GitHub URLs, if the url isn't for GitHub
    #we assume it's a direct download link (download command will fail, if
    #it's not)
    _cpp_contains(_cud_is_gh "github" "${_cud_url}")
    if(_cud_is_gh)
        set(_cud_header "include(recipes/cpp_get_from_gh)")
        set(_cud_gh "_cpp_get_from_gh(\${_cgr_tar} \${_cgr_version} ")
        set(_cud_gh "${_cud_gh} ${_cud_url} ${ARGN})")
        set(_cud_body "${_cud_header}\n${_cud_gh}")
    else()
        set(_cud_body "_cpp_download_tarball(\${_cgr_tar} ${_cud_url})")
    endif()
    set(${_cud_contents} "${_cud_body}" PARENT_SCOPE)
endfunction()
