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

## Function for returning all of the possible properties a target may have.
#
# This function is ripped from Stack Overflow: "How to print all the properties
# of a target in cmake.
#
# .. note::
#
#     The resulting list contains some properties that are blacklisted for
#     interface targets. See :ref:`cpp_target_get_whitelist-label` for getting
#     only the whitelisted properties.
#
# :param result: The identifier to hold the returned list.
function(_cpp_target_get_all_properties _ctgap_result)
    execute_process(
        COMMAND ${CMAKE_COMMAND} --help-property-list
        OUTPUT_VARIABLE _ctgap_temp_list
    )
    string(REGEX REPLACE ";" "\\\\;" _ctgap_temp_list "${_ctgap_temp_list}")
    string(REGEX REPLACE "\n" ";" _ctgap_temp_list "${_ctgap_temp_list}")
    # Fix Stack Overflow: How can I remove the the location property may not be
    # read from target error i
    list(
        FILTER _ctgap_temp_list EXCLUDE REGEX "^LOCATION$|^LOCATION_|_LOCATION$"
    )
    list(REMOVE_DUPLICATES _ctgap_temp_list)
    set(${_ctgap_result} "${_ctgap_temp_list}" PARENT_SCOPE)
endfunction()
