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

## Negates the input variable
#
# CMakes logic constructs are hard to use correctly, including the ``NOT``
# construct. This function encapsulates the logic for negating a boolean,
# *i.e.*, turning true into false and false into true. It works for any value
# that CMake establishes as having a truth-ness to it.
#
# :param result: An identifier to hold the negated result
# :param input: A boolean to negate
function(_cpp_negate _cn_result _cn_input)
    if("${_cn_input}")
        set(${_cn_result} 0 PARENT_SCOPE)
    else()
        set(${_cn_result} 1 PARENT_SCOPE)
    endif()
endfunction()
