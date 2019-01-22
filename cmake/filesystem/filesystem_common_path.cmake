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

## Given a set of paths determines "``CMAKE_PREFIX_PATH``" for the set
#
# When we find a dependency we get back a target with the paths baked in. If we
# want to find the same target again the easiest way is to know the install root
# common to those paths. This function determines that root path.
#
# :param path: An identifier to hold the returned root path
# :param list: The list of paths we want the common root of.
function(_cpp_filesystem_common_path _cfcp_path _cfcp_list)

endfunction()
