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

## Given a handle to an object returns the type of the object
#
# This function assumes the handle is of the form ``_cpp_<gibberish>_<type>``
# where gibberish is a 5 character long random string, hence everything from the
# 12-th character on is the type
#
# :param result: An identifier to store the result in.
# :param handle: The object we want the type of.
#
function(_cpp_Object_get_type _cOgt_result _cOgt_handle)
    string(SUBSTRING ${_cOgt_handle} 11 -1 _cOgt_type)
    set(${_cOgt_result} "${_cOgt_type}" PARENT_SCOPE)
endfunction()
