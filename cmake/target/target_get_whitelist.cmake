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

include(target/target_get_all_properties)

## Function for returning only the whitelisted properties for interface targets
#
# This function is ripped from Stack Overflow: "How to print all the properties
# of a target in cmake.
#
# :param result: The identifier to contain the returned list.
function(_cpp_target_get_whitelist _ctgw_result)
    _cpp_target_get_all_properties(_ctgw_all_props)

    #Very long regex defining acceptable prefixes for imported targets
    set(_ctgw_re1 "^(INTERFACE|[_a-z]|IMPORTED_LIBNAME_|MAP_IMPORTED_CONFIG_)")
    set(_ctgw_re2 "|^(COMPATIBLE_INTERFACE_(BOOL|NUMBER_MAX|NUMBER_MIN|STRING)")
    set(_ctgw_re3 "|EXPORT_NAME|IMPORTED(_GLOBAL|_CONFIGURATIONS|_LIBNAME)")
    set(_ctgw_re4 "?|NAME|TYPE|NO_SYSTEM_FROM_IMPORTED)$")
    set(_ctgw_re "${_ctgw_re1}${_ctgw_re2}${_ctgw_re3}${_ctgw_re4}")

    set(_ctgw_whitelist "")
    foreach(_ctgw_prop ${_ctgw_all_props})
        if(_ctgw_prop MATCHES "${_ctgw_re}")
            list(APPEND _ctgw_whitelist ${_ctgw_prop})
        endif()
    endforeach()

    set(${_ctgw_result} "${_ctgw_whitelist}" PARENT_SCOPE)
endfunction()
