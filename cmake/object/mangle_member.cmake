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
include(utility/set_return)

## Mangles a member name for storage as a property
#
# For all intents and purposes this is a private member function of the Object
# class. Internally it is used to ensure that user provided member function
# names do not collide with properties that CMake defines already. User-defined
# member names will collide if they both call this function with the same input.
#
# :param result: The computed mangled name for the member
# :param name: The name this function will mangle
function(_cpp_Object_mangle_member _cOmm_result _cOmm_name)
    string(TOLOWER ${_cOmm_name} _cOmm_lc)
    _cpp_set_return(${_cOmm_result} _cpp_${_cOmm_lc})
endfunction()
