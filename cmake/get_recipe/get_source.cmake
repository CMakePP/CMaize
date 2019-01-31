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

function(_cpp_GetRecipe_get_source _cGgs_handle _cGgs_tar)
    _cpp_Object_has_base(${_cGgs_handle} _cGgs_is_disk GetFromDisk)
    _cpp_Object_has_base(${_cGgs_handle} _cGgs_is_url GetFromURL)

    if(_cGgs_is_disk)
        _cpp_GetFromDisk_get_source(${_cGgs_handle} ${_cGgs_tar})
    elseif(_cGgs_is_url)
        _cpp_GetFromURL_get_source(${_cGgs_handle} ${_cGgs_tar})
    endif()
endfunction()
