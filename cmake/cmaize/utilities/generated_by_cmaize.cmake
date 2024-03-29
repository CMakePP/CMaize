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

#[[[
# Comment stating that the file was generated by CMaize. Usually this should
# be added at the top of the file.
#
# :param _cgbc_message: Return variable with the message.
# :type _cgbc_message: desc
#
# :returns: CMake comment stating that the file was generated by CMaize.
# :rtype: desc
#]]
function(_cmaize_generated_by_cmaize __cgbc_message)

    set(
        "${__cgbc_message}"
        "# This file is generated by CMaize.
# 
# NOTE: Any modifications made in this file may be lost the next time
#       CMake is run."
)

    cpp_return("${__cgbc_message}")

endfunction()
