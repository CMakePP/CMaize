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
include(cmaize/user_api/dependencies/impl_/check_optional_flag)

ct_add_test(NAME "test_check_optional_flag")
function("${test_check_optional_flag}")

    ct_add_section(NAME "empty_string" EXPECTFAIL)
    function("${empty_string}")

        _check_optional_flag("")

    endfunction()

    ct_add_section(NAME "value_is_true" EXPECTFAIL)
    function("${value_is_true}")

        _check_optional_flag(TRUE)

    endfunction()

    ct_add_section(NAME "value_is_on" EXPECTFAIL)
    function("${value_is_on}")

        _check_optional_flag(ON)

    endfunction()

    ct_add_section(NAME "value_is_false" EXPECTFAIL)
    function("${value_is_false}")

        _check_optional_flag(FALSE)

    endfunction()

    ct_add_section(NAME "value_is_off" EXPECTFAIL)
    function("${value_is_off}")

        _check_optional_flag(OFF)

    endfunction()

    ct_add_section(NAME "flag_value" EXPECTFAIL)
    function("${flag_value}")

        set(ENABLE_DEPENDENCY ON)
        _check_optional_flag("${ENABLE_DEPENDENCY}")

    endfunction()

    ct_add_section(NAME "valid_flag")
    function("${valid_flag}")
    include(cmaize/user_api/dependencies/impl_/check_optional_flag)
        _check_optional_flag(ENABLE_DEPENDENCY)

    endfunction()

endfunction()
