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

include(cmake_test/cmake_test)

ct_add_test("test_cpp_find_or_build_dependency")
function("${test_cpp_find_or_build_dependency}")

    include(cpp/user_api/find_or_build_dependency)

    cpp_find_or_build_dependency(Catch2 URL https://github.com/catchorg/Catch2)

endfunction()
