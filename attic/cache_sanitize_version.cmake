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

function(_cpp_cache_sanitize_version _ccsv_output _ccsv_version)
    _cpp_is_empty(_ccsv_no_ver _ccsv_version)
    if(_ccsv_no_ver)
        set(_ccsv_eff_ver "latest")
    else()
        set(_ccsv_eff_ver ${_ccsv_version})
    endif()
    set(${_ccsv_output} ${_ccsv_eff_ver} PARENT_SCOPE)
endfunction()
