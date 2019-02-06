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
function(_cpp_cache_find_dependency _ccfd_found _ccfd_cache _ccfd_name
                                    _ccfd_version _ccfd_comps)
    set(${_ccfd_found} FALSE PARENT_SCOPE) #Will change if we do find it
    _cpp_cache_get_recipe_path(_ccfd_get)
endfunction()
