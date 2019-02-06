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
include(string/split)
## Separates a scoped target
#
# Modern CMake recommends using targets of the form ``project::component``. This
# function will parse the name of a target and split it on the ``::``. If there
# is no ``::`` the component return will be empty.
#
# :param project: An identifer who's value will be set to
function(_cpp_parse_target _cpt_project _cpt_component _cpt_target)
    _cpp_string_split(_cpt_rv "${_cpt_target}" "::")
    list(LENGTH _cpt_rv _cpt_n)
    list(GET _cpt_rv 0 _cpt_rv0)
    if("${_cpt_n}" STREQUAL "2")
        list(GET _cpt_rv 1 _cpt_rv1)
    else()
        set(_cpt_rv1 "")
    endif()
    _cpp_set_return(${_cpt_project} "${_cpt_rv0}")
    _cpp_set_return(${_cpt_component} "${_cpt_rv1}")
endfunction()
