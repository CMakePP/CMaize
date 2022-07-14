include(cmake_test/cmake_test)

#[[[
# Test the ``CMakePackageManager`` class.
#]]
ct_add_test(NAME "test_cmake_package_manager")
function("${test_cmake_package_manager}")
    include(cmaize/package_managers/cmake_package_manager)

    ct_add_section(NAME "can_add_single_path")
    function("${can_add_single_path}")

        set(corr "/some/path")

        CMakePackageManager(pm_obj)

        CMakePackageManager(add_path "${pm_obj}" "/some/path")

        CMakePackageManager(GET "${pm_obj}" _search_paths search_paths)

        ct_assert_equal(corr "${_search_paths}")

    endfunction()

endfunction()
