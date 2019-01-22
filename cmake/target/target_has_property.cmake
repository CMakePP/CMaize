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
include(cpp_cmake_helpers)
include(target/target_get_whitelist)

## Function for determining if a target has a specific property
#
# For whatever reason CMake makes it a pain to determine if a target has a
# particular property set on it. This function wraps the process of doing that.
# More specifically this function first checks if the property is "whitelisted".
# If the property is not on the whitelist of properties it obviously can not be
# set on the target, so this function returns false. Assuming the property is
# allowed we next call CMake's ``get_target_property``. If the result is
# "NOTFOUND" it means that the property was not set, otherwise it was set.
#
# :param result: The identifier to use for the returned result.
# :param target: The name of the target to examine.
# :param prop: The property we are looking for.
function(_cpp_target_has_property _cthp_result _cthp_target _cthp_prop)
    #Worry about whether this is a whitelisted property
    get_target_property(_cthp_type ${_cthp_target} TYPE)
    if("${_cthp_type}" STREQUAL "INTERFACE_LIBRARY")
        _cpp_target_get_all_properties(_cthp_all)
        _cpp_target_get_whitelist(_cthp_wl)
        #Use list find so we match whole elements
        list(FIND _cthp_wl "${_cthp_prop}" _cthp_is_bl)
        list(FIND _cthp_all "${_cthp_prop}" _cthp_is_real)
        if("${_cthp_is_bl}" STREQUAL "-1")
            if("${_cthp_is_real}" STREQUAL "-1")
                #not a CMake recognized property so it can't be blacklisted
            else()
                set(${_cthp_result} FALSE PARENT_SCOPE)
                return()
            endif()
        endif()
    endif()

    #It's a whitelisted property (or our target doesn't have a whitelist)
    get_target_property(_cthp_has_prop ${_cthp_target} ${_cthp_prop})
    if("${_cthp_has_prop}" STREQUAL "_cthp_has_prop-NOTFOUND")
       set(${_cthp_result} FALSE PARENT_SCOPE)
    else()
        set(${_cthp_result} TRUE PARENT_SCOPE)
    endif()
endfunction()
