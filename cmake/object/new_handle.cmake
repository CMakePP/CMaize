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

## Generates a handle that can be used for a new object
#
# This function creates a CMake target that will store the state of an object.
# The resulting target will have a unique name and be mangled in such a way that
# it should not interfere with targets created by other CMake projects or for
# other CPP object instances (barring malicious intent). For all intents and
# purposes this is a private member function of the Object class.
#
# :param var: The identifier to assign the handle to
#
function(_cpp_Object_new_handle _cOnh_var)
    set(_cOnh_not_good TRUE)
    while(_cOnh_not_good)
        string(RANDOM _cOnh_gibberish)
        set(_cOnh_handle _cpp_${_cOnh_gibberish})
        _cpp_is_target(_cOnh_not_good ${_cOnh_handle})
    endwhile()
    add_library(${_cOnh_handle} INTERFACE)
    set(${_cOnh_var} ${_cOnh_handle} PARENT_SCOPE)
endfunction()
