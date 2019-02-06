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

## Function for creating the source fils for a dummy C++ executable.
#
# This function is similar to :ref:`cpp_dummy_cxx_library-label` with the only
# difference being that it creates source for an executable and not a library.
# The resulting executable does nothing aside from return the number 2.
#
# :param prefix: The directory where the source should be written to. The
#     resulting source file will be called ``<prefix>/main.cpp``.
function(_cpp_dummy_cxx_executable _cdce_prefix)
    file(WRITE ${_cdce_prefix}/main.cpp "int main(){return 2;}")
endfunction()
