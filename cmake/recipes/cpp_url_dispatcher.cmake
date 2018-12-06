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
include(recipes/cpp_get_from_gh)
function(_cpp_url_dispatcher _cud_contents _cud_url)
    #At the moment we know how to parse GitHub URLs, if the url isn't for GitHub
    #we assume it's a direct download link (download command will fail, if
    #it's not)
    _cpp_contains(_cud_is_gh "github" "${_cud_url}")
    _cpp_contains(_cud_is_tar "gz" "${_cud_url}")
    if(${_cud_is_gh} AND ${_cud_is_tar}) #User linked to a specific asset,
        set(_cud_body "_cpp_download_tarball(\${_cgr_tar} ${_cud_url})")
    elseif(_cud_is_gh)
        _cpp_gh_get_recipe_body(_cud_body "${_cud_url}" ${ARGN})
    else()
        set(_cud_body "_cpp_download_tarball(\${_cgr_tar} ${_cud_url})")
    endif()
    set(${_cud_contents} "${_cud_body}" PARENT_SCOPE)
endfunction()
