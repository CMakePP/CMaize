include_guard()
include(get_recipe/get_from_url/get_from_github/get_from_github)
include(get_recipe/get_from_url/ctor)

## Dispatches among the various way to get source from the internet.
#
# This function is responsible for calling the correct ctor for the various
# classes derived from the ``GetFromURL`` class.
#
#
# :param handle: An identifier to hold the handle to the returned object.
# :param url: The URL to get the source from.
# :param branch: The branch of the source code to use.
# :param version: The version of the source code this recipe is for.
# :param private: If true this source comes from a private GitHub repo
function(_cpp_GetFromURL_factory _cGf_handle _cGf_url _cGf_branch _cGf_version
                                 _cGf_private)
    _cpp_contains(_cGf_is_gh "github.com" "${_cGf_url}" )
    if(_cGf_is_gh)
        _cpp_GetFromGithub_ctor(
            _cGf_temp
            "${_cGf_url}"
            "${_cGf_branch}"
            "${_cGf_version}"
            "${_cGf_private}"
        )
    else()
        _cpp_GetFromURL_ctor(_cGf_temp "${_cGf_url}" "${_cGf_version}")
    endif()
    _cpp_set_return(${_cGf_handle} ${_cGf_temp})
endfunction()
