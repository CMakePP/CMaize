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

ct_add_test(NAME "test_sanitize_url")
function("${test_sanitize_url}")
    include(cmaize/utilities/sanitize_url)

    ct_add_section(NAME "blank_url")
    function("${blank_url}")

        cmaize_sanitize_url(__result "")

        ct_assert_equal(__result "")

    endfunction()

    ct_add_section(NAME "base_url")
    function("${base_url}")

        cmaize_sanitize_url(__result "github.com/test_user/repository")

        ct_assert_equal(__result "github.com/test_user/repository")

    endfunction()

    ct_add_section(NAME "removes_http_scheme")
    function("${removes_http_scheme}")

        cmaize_sanitize_url(
            __result "http://github.com/test_user/repository"
        )

        ct_assert_equal(__result "github.com/test_user/repository")

    endfunction()

    ct_add_section(NAME "removes_other_scheme")
    function("${removes_other_scheme}")

        cmaize_sanitize_url(
            __result "file://github.com/test_user/repository"
        )

        ct_assert_equal(__result "github.com/test_user/repository")

    endfunction()

    ct_add_section(NAME "check_domain_without_slash")
    function("${check_domain_without_slash}")

        cmaize_sanitize_url(
            __result "github.com/test_user/repository" DOMAIN github.com
        )

        ct_assert_equal(__result "github.com/test_user/repository")

    endfunction()

    ct_add_section(NAME "check_domain_w_domain_not_at_start")
    function("${check_domain_w_domain_not_at_start}")

        cmaize_sanitize_url(
            __result "www.github.com/test_user/repository" DOMAIN github.com
        )

        ct_assert_equal(__result "www.github.com/test_user/repository")

    endfunction()

    ct_add_section(NAME "check_domain_w_slash")
    function("${check_domain_w_slash}")

        cmaize_sanitize_url(
            __result "github.com/test_user/repository" DOMAIN github.com/
        )

        ct_assert_equal(__result "github.com/test_user/repository")

    endfunction()

    ct_add_section(NAME "wrong_domain" EXPECTFAIL)
    function("${wrong_domain}")

        cmaize_sanitize_url(
            __result "github.com/test_user/repository" DOMAIN bitbucket.com
        )

    endfunction()

    ct_add_section(NAME "check_domain_w_scheme")
    function("${check_domain_w_scheme}")

        cmaize_sanitize_url(
            __result
            "https://github.com/test_user/repository"
            DOMAIN github.com
        )

        ct_assert_equal(__result "github.com/test_user/repository")

    endfunction()

endfunction()