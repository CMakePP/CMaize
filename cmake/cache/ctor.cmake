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
include(object/object)
include(utility/assert_no_extra_args)
include(utility/mkdir_if_dne)
include(utility/set_return)

## Provides an object-oriented view of the Cache
#
# Given a directory to use as a cache, this will create a Cache object from that
# directory. If the directory exists it will be used as is, otherwise that
# directory will be created.
#
# :Members:
#
#   * root - The root directory of the Cache
#
# :param handle: An identifier to give the handle to.
# :param path: The directory to use as the Cache
function(_cpp_Cache_ctor _cCc_handle _cCc_path)
    _cpp_assert_no_extra_args("${ARGN}")
    _cpp_mkdir_if_dne("${_cCc_path}")
    _cpp_Object_ctor(_cCc_temp)
    _cpp_Object_set_type(${_cCc_temp} Cache)
    _cpp_Object_add_members(${_cCc_temp} root)
    _cpp_Object_set_value(${_cCc_temp} root ${_cCc_path})
    _cpp_set_return(${_cCc_handle} ${_cCc_temp})
endfunction()
