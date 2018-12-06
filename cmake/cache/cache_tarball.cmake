################################################################################
#                        Copyright 2018 Ryan M. Richard                        #
#       Licensed under the Apache License, Version 2.0 (the "License");        #
#       you may not use this file except in compliance with the License.       #
#                   You may obtain a copy of the License at                    #
#                                                                              #
#                  http://www.apache.org/licenses/LICENSE-2.0                  #
#                                                                              #
#     Unless required by applicable law or agreed to in writing, software      #
#      distributed under the License is distributed on an "AS IS" BASIS,       #
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.   #
#     See the License for the specific language governing permissions and      #
#                        limitations under the License.                        #
################################################################################

include_guard()
include(cache/cache_paths)
include(cache/cache_get_recipe)

function(_cpp_cache_tarball _cct_output _cct_cache _cct_name _cct_ver)
    _cpp_cache_tarball_path(
        _cct_tarball ${_cct_cache} ${_cct_name} "${_cct_ver}"
    )
    _cpp_does_not_exist(_cct_tar_dne ${_cct_tarball})
    if(_cct_tar_dne)
        _cpp_error(
            "Tarball:\n  ${_cct_tarball}\ndoes not exist.\n"
            "Troubleshooting: Did you call _cpp_cache_add_dependency?"
        )
    endif()
    set(${_cct_output} ${_cct_tarball} PARENT_SCOPE)
endfunction()


function(_cpp_cache_add_tarball _ccat_cache _ccat_name _ccat_version)
    _cpp_cache_tarball_path(
        _ccat_tarball ${_ccat_cache} ${_ccat_name} "${_ccat_version}"
    )

    _cpp_cache_get_recipe(_ccat_get_recipe ${_ccat_cache} ${_ccat_name})
    include(${_ccat_get_recipe})
    _cpp_get_recipe(${_ccat_tarball}.temp "${_ccat_version}")

    #We always overwrite if we weren't given a version, otherwise we make sure
    #it's the same tarball
    _cpp_is_not_empty(_ccat_have_ver _ccat_version)
    _cpp_exists(_ccat_have_tar ${_ccat_tarball})
    if(_ccat_have_ver AND _ccat_have_tar)
        file(SHA1 ${_ccat_tarball}.temp _ccat_new_hash)
        file(SHA1 ${_ccat_tarball} _ccat_old_hash)
        _cpp_are_not_equal(_ccat_not_same ${_ccat_new_hash} ${_ccat_old_hash})
        if(_ccat_not_same)
            _cpp_error(
                "Tarball ${_ccat_tarball}.temp and ${_ccat_tarball} are not the"
                " same.  Troubleshooting: Did the source change?"
            )
        endif()
    else()
        configure_file(${_ccat_tarball}.temp ${_ccat_tarball} COPYONLY)
    endif()
endfunction()
