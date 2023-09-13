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
# Test the ``InstalledTarget`` class.
#]]
ct_add_test(NAME "test_tgt")
function("${test_tgt}")
    include(cmaize/targets/installed_target)

    #[[[
    # Test ``InstalledTarget(CTOR`` method.
    #]]
    ct_add_section(NAME "test_ctor")
    function("${test_ctor}")

        ct_add_section(NAME "test_tgt_name")
        function("${test_tgt_name}")
            set(tgt_name "test_ctor_test_tgt_name")

            InstalledTarget(CTOR
                tgt_obj "${tgt_name}" "${CMAKE_CURRENT_SOURCE_DIR}"
            )

            CMaizeTarget(target "${tgt_obj}" result)

            ct_assert_equal(result "${tgt_name}")
        endfunction()

        ct_add_section(NAME "test_dir_exists")
        function("${test_dir_exists}")

            set(tgt_name "test_ctor_test_dir_exists")

            InstalledTarget(CTOR
                tgt_obj "${tgt_name}" "${CMAKE_CURRENT_SOURCE_DIR}"
            )

            InstalledTarget(GET "${tgt_obj}" result root_path)

            ct_assert_equal(result "${CMAKE_CURRENT_SOURCE_DIR}")

        endfunction()

        ct_add_section(NAME "test_dir_nonexistant" EXPECTFAIL)
        function("${test_dir_nonexistant}")

            set(tgt_name "test_ctor_test_dir_nonexistant")

            InstalledTarget(CTOR
                tgt_obj "${tgt_name}" "${CMAKE_CURRENT_SOURCE_DIR}/nonexistant"
            )
        
        endfunction()

    endfunction()

endfunction()
