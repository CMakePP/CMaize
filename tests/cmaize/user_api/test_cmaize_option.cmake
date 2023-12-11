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
# Test the cmaize_option function.
#]]
ct_add_test(NAME "test_cmaize_option")
function("${test_cmaize_option}")
    include(cmaize/project/projects)
    include(cmaize/user_api/cmaize_option)
    include(cmaize/user_api/cmaize_project)

    project("ATestCMaizeProject")
    cmaize_project("ATestCMaizeProject")
    cpp_get_global(proj_obj CMAIZE_TOP_PROJECT)

    ct_add_section(NAME "not_set_at_all")
    function("${not_set_at_all}")

        cmaize_option("Hello" "World")

        # Should set the variable in this scope
        ct_assert_equal(Hello "World")

        # Should be added to the project
        CMaizeProject(get_config_option "${proj_obj}" value "Hello")
        ct_assert_equal(value "World")

    endfunction()

    ct_add_section(NAME "set_in_cache")
    function("${set_in_cache}")

        set("a_cache_option" 42 CACHE STRING "" FORCE)

        cmaize_option("a_cache_option" 100)

        # Did not overwrite variable
        ct_assert_equal(a_cache_option 42)

        # Should have been added to the project
        CMaizeProject(get_config_option "${proj_obj}" value "a_cache_option")
        ct_assert_equal(value 42)

    endfunction()

    ct_add_section(NAME "set_as_variable")
    function("${set_as_variable}")

        set(a_variable_option "foo")

        cmaize_option(a_variable_option "bar")

        # Did not overwrite variable
        ct_assert_equal(a_variable_option "foo")

        # Should have been added to the project
        CMaizeProject(get_config_option "${proj_obj}" value "a_variable_option")
        ct_assert_equal(value "foo")

    endfunction()

    ct_add_section(NAME "set_in_project")
    function("${set_in_project}")

        CMaizeProject(set_config_option "${proj_obj}" a_proj_option "bar")

        cmaize_option("a_proj_option" "foo")

        # Did not overwrite variable
        ct_assert_equal(a_proj_option "bar")

        # Should have been added to the project
        CMaizeProject(get_config_option "${proj_obj}" value "a_proj_option")
        ct_assert_equal(value "bar")

    endfunction()
endfunction()

ct_add_test(NAME "test_cmaize_option_list")
function("${test_cmaize_option_list}")
    include(cmaize/project/projects)
    include(cmaize/user_api/cmaize_option)
    include(cmaize/user_api/cmaize_project)

    project("ATestCMaizeProject")
    cmaize_project("ATestCMaizeProject")
    cpp_get_global(proj_obj CMAIZE_TOP_PROJECT)

    ct_add_section(NAME "zero_arguments")
    function("${zero_arguments}")
        cmaize_option_list()
    endfunction()

    ct_add_section(NAME "one_argument" EXPECTFAIL)
    function("${one_argument}")
        cmaize_option_list("foo")
    endfunction()

    ct_add_section(NAME "two_arguments")
    function("${two_arguments}")
        cmaize_option_list("foo" 42)
        ct_assert_equal(foo 42)
    endfunction()

    ct_add_section(NAME "three_arguments" EXPECTFAIL)
    function("${three_arguments}")
        cmaize_option_list("foo" 42 "bar")
    endfunction()

    ct_add_section(NAME "four_arguments")
    function("${four_arguments}")
        cmaize_option_list(
            "foo" 42
            "bar" "hello"
        )
        ct_assert_equal(foo 42)
        ct_assert_equal(bar "hello")
    endfunction()
endfunction()
