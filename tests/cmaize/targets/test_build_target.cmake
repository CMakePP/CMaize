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

#[[[
# Test the ``BuildTarget`` class.
#]]
ct_add_test(NAME "test_build_target")
function("${test_build_target}")
    include(cmaize/targets/build_target)

    #[[[
    # Test ``BuildTarget(make_target`` method.
    #]]
    ct_add_section(NAME "test_make_target")
    function("${test_make_target}")

        ct_add_section(NAME "virtual_throw" EXPECTFAIL)
        function("${virtual_throw}")
            set(tgt_name "test_build_target_make_target_virtual_throw")

            BuildTarget(CTOR tgt_obj "${tgt_name}")

            BuildTarget(make_target "${tgt_obj}")
        endfunction()

    endfunction()

    #[[[
    # Test ``BuildTarget(_create_target`` method.
    #]]
    ct_add_section(NAME "test__create_target")
    function("${test__create_target}")

        ct_add_section(NAME "virtual_throw" EXPECTFAIL)
        function("${virtual_throw}")
            set(tgt_name "test_build_target__create_target_virtual_throw")

            BuildTarget(CTOR tgt_obj "${tgt_name}")

            BuildTarget(_create_target "${tgt_obj}")
        endfunction()

    endfunction()

    #[[[
    # Test ``BuildTarget(_set_include_directories`` method.
    #]]
    ct_add_section(NAME "test__set_include_directories")
    function("${test__set_include_directories}")

        ct_add_section(NAME "virtual_throw" EXPECTFAIL)
        function("${virtual_throw}")
            set(tgt_name "test_build_target__set_include_directories_virtual_throw")

            BuildTarget(CTOR tgt_obj "${tgt_name}")

            BuildTarget(_set_include_directories "${tgt_obj}")
        endfunction()

    endfunction()

endfunction()
