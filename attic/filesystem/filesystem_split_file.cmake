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

## Reads a file into a list where each line is an element
#
# The contents of this function are taken from the CMake mailing list,
# specifically `here <https://cmake.org/pipermail/cmake/2007-May/014222.html>`_.
#
# :param list: The identifier to contain the resulting list
# :param file: The file we are splitting into a list
#
function(_cpp_split_file _csf_list _csf_file)
    file(READ ${_csf_file} _csf_buffer)
    #Need to switch \n to semicolons, but first have to protect existing ;'s so
    #we don't get confused
    string(REGEX REPLACE ";" "\\\\;" _csf_buffer "${_csf_buffer}")
    string(REGEX REPLACE "\n" ";" _csf_buffer "${_csf_buffer}")
    set(${_csf_list} "${_csf_buffer}" PARENT_SCOPE)
endfunction()
