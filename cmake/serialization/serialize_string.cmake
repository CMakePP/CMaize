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

## Serializes a string according to the JSON standard.
#
# Since CMake doesn't distinguish between strings, numbers, and booleans this
# function is actually responsible for serializing all of them. The actual
# serialization process is trivial, we just return the value in escaped double
# quotes.
#
# :param return: An identifier to hold the serialized string.
# :param value: The string to serialize
function(_cpp_serialize_string _css_return _css_value)
    set(${_css_return} "\"${_css_value}\"" PARENT_SCOPE)
endfunction()
