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
include(find_recipe/factory_add_kwargs)
include(kwargs/kwargs)

function(_cpp_find_dependency_add_kwargs _cfdak_kwargs)
    _cpp_FindRecipe_factory_add_kwargs(${_cfdak_kwargs})
    _cpp_Kwargs_add_keywords(
        ${_cfdak_kwargs} TOGGLES OPTIONAL OPTIONS RESULT LISTS PATHS
    )
    _cpp_Kwargs_set_default(${_cfdak_kwargs} RESULT CPP_DEV_NULL)
endfunction()
