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

ct_add_test(NAME "test_glob_files")
function("${test_glob_files}")
    include(cmaize/utilities/glob_files)

    ct_add_section(NAME "returns_empty_w_no_valid_files")
    function("${returns_empty_w_no_valid_files}")

        _cmaize_glob_files(file_list "${CMAKE_CURRENT_SOURCE_DIR}" "bad_ext")

        list(LENGTH file_list file_list_n)
        ct_assert_equal(file_list_n 0)

    endfunction()

    ct_add_section(NAME "returns_empty_w_no_valid_directory")
    function("${returns_empty_w_no_valid_directory}")

        _cmaize_glob_files(
            file_list
            "${CMAKE_CURRENT_SOURCE_DIR}/nonexistant"
            "bad_ext"
        )

        list(LENGTH file_list file_list_n)
        ct_assert_equal(file_list_n 0)

    endfunction()

    ct_add_section(NAME "returns_valid_files")
    function("${returns_valid_files}")

        # This relies on there being a 'CMakeLists.txt' file in the test
        # source directory
        _cmaize_glob_files(
            file_list
            "${CMAKE_CURRENT_SOURCE_DIR}"
            "txt"
        )

        list(LENGTH file_list file_list_n)
        ct_assert_true(file_list_n)

    endfunction()

    ct_add_section(NAME "returns_valid_files_recursively")
    function("${returns_valid_files_recursively}")

        # This relies on there being a 'CMakeLists.txt' file in the test
        # source directory
        _cmaize_glob_files(
            file_list
            "${CMAKE_CURRENT_SOURCE_DIR}/.."
            "txt"
        )

        list(LENGTH file_list file_list_n)
        ct_assert_true(file_list_n)

    endfunction()

    ct_add_section(NAME "returns_files_w_file_and_ext_lists")
    function("${returns_files_w_file_and_ext_lists}")

        # This relies on there being a 'CMakeLists.txt' file in the test
        # source directory
        _cmaize_glob_files(
            file_list
            "${CMAKE_CURRENT_SOURCE_DIR}/..;${CMAKE_CURRENT_SOURCE_DIR}"
            "txt;cmake"
        )

        list(LENGTH file_list file_list_n)
        ct_assert_true(file_list_n)

    endfunction()

endfunction()