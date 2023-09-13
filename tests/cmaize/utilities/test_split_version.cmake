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

ct_add_test(NAME "test_split_version")
function("${test_split_version}")
    include(cmaize/utilities/split_version)

    #[[[
    # Test that a bad version (even with spaces) will end up in the major
    # version.
    #]]
    ct_add_section(NAME "bad_version")
    function("${bad_version}")

        cmaize_split_version(major minor patch tweak "bad version")

        ct_assert_equal(major "bad version")
        ct_assert_equal(minor "")
        ct_assert_equal(patch "")
        ct_assert_equal(tweak "")

    endfunction()

    #[[[
    # Test that a blank version string gives blank components.
    #]]
    ct_add_section(NAME "blank_version")
    function("${blank_version}")

        cmaize_split_version(major minor patch tweak "")

        ct_assert_equal(major "")
        ct_assert_equal(minor "")
        ct_assert_equal(patch "")
        ct_assert_equal(tweak "")

    endfunction()

    #[[[
    # Test that a partial versions extract up to the parts given.
    #]]    
    ct_add_section(NAME "partial_version")
    function("${partial_version}")

        ct_add_section(NAME "major")
        function("${major}")

            cmaize_split_version(major minor patch tweak "1")

            ct_assert_equal(major "1")
            ct_assert_equal(minor "")
            ct_assert_equal(patch "")
            ct_assert_equal(tweak "")

        endfunction()

        ct_add_section(NAME "major_minor")
        function("${major_minor}")

            cmaize_split_version(major minor patch tweak "1.22")

            ct_assert_equal(major "1")
            ct_assert_equal(minor "22")
            ct_assert_equal(patch "")
            ct_assert_equal(tweak "")

        endfunction()

        ct_add_section(NAME "major_minor_patch")
        function("${major_minor_patch}")

            cmaize_split_version(major minor patch tweak "1.22.333")

            ct_assert_equal(major "1")
            ct_assert_equal(minor "22")
            ct_assert_equal(patch "333")
            ct_assert_equal(tweak "")

        endfunction()

    endfunction()

    #[[[
    # Test that a full version is pulled apart correctly.
    #]]
    ct_add_section(NAME "full_version")
    function("${full_version}")

        cmaize_split_version(major minor patch tweak "1.22.333.4444-alpha")

        ct_assert_equal(major "1")
        ct_assert_equal(minor "22")
        ct_assert_equal(patch "333")
        ct_assert_equal(tweak "4444-alpha")

    endfunction()

endfunction()