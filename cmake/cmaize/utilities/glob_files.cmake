# Copyright 2023 CMakePP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

include_guard()
include(cmakepp_lang/cmakepp_lang)

function(_cmaize_glob_files _cgf_return_files _cgf_dirs _cgf_file_exts)

    set("${_cgf_return_files}" "")
    foreach(_cgf_dir_i ${_cgf_dirs})
        foreach(_cgf_ext_i ${_cgf_file_exts})
            file(GLOB_RECURSE _cgf_files_tmp
                LIST_DIRECTORIES false
                CONFIGURE_DEPENDS
                "${_cgf_dir_i}/*.${_cgf_ext_i}"
            )
            list(APPEND "${_cgf_return_files}" ${_cgf_files_tmp})
        endforeach()
    endforeach()

    cpp_return("${_cgf_return_files}")

endfunction()
