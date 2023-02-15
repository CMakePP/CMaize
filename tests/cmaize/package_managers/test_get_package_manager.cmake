include(cmake_test/cmake_test)

#[[[
# Test the ``CMakePackageManager`` class.
#]]
ct_add_test(NAME "test_get_package_manager")
function("${test_get_package_manager}")
    include(cmakepp_lang/cmakepp_lang)
    include(cmaize/package_managers/get_package_manager)

    ct_add_section(NAME "invalid_instance" EXPECTFAIL)
    function("${invalid_instance}")

        get_package_manager_instance(_ii_result "invalid")

    endfunction()

    ct_add_section(NAME "existing_instance")
    function("${existing_instance}")

        PackageManager(CTOR _ei_instance)
        cpp_set_global(__CMAIZE_SINGLETON_packagemanager__ "${_ei_instance}")

        get_package_manager_instance(_ei_result "packagemanager")

        ct_assert_equal(_ei_instance "${_ei_result}")

    endfunction()

    ct_add_section(NAME "nonexistant_instance")
    function("${nonexistant_instance}")

        get_package_manager_instance(_ni_result "packagemanager")

        PackageManager(GET "${_ni_result}" _ni_type type)

        ct_assert_equal(_ni_type "None")

    endfunction()

endfunction()
