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
include(cpp/targets/cxx_target)

cpp_class(CXXLibrary CXXTarget)

    cpp_member(_create_target CXXLibrary)
    function("${_create_target}" _it_this)
        CXXLibrary(GET "${_it_this}" _it_name name)
        CXXLibrary(GET "${_it_this}" _it_src sources)
        add_library("${_it_name}" "${_it_src}")
    endfunction()

cpp_end_class()


