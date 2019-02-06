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

## Creates a tarball of locally stored source code
#
# :param handle: The handle to the GetFromDisk object
# :param tar: The full path to where the tarball should go.
function(_cpp_GetFromDisk_get_source _cGgs_handle _cGgs_tar)
    _cpp_Object_get_value(${_cGgs_handle} _cGgs_dir dir)
    _cpp_tar_directory(${_cGgs_tar} ${_cGgs_dir})
endfunction()
