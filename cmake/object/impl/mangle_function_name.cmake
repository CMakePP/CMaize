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

## Provides a unique identifier for a function
#
#  The goal of mangling a function name is to create a member whose name is
#  unlikely to collide with any other member.
#
# :param out: The identifier to hold the mangled name
# :param type: The type of the object getting the member function
# :param name: The name of the function.
function(_cpp_mangle_function_name _cOmfn_out _cOmfn_type _cOmfn_name)
    _cpp_set_return(${_cOmfn_out} _cpp_fxn_${_cOmfn_type}_${_cOmfn_name})
endfunction()
