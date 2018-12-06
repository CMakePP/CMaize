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
