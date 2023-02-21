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