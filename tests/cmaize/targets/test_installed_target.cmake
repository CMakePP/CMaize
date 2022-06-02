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

        ct_add_section(NAME "test_dir_exists")
        function("${test_dir_exists}")

            InstalledTarget(CTOR tgt_obj "${CMAKE_CURRENT_SOURCE_DIR}")

            InstalledTarget(GET "${tgt_obj}" result root_path)

            ct_assert_equal(result "${CMAKE_CURRENT_SOURCE_DIR}")

        endfunction()

        ct_add_section(NAME "test_dir_nonexistant" EXPECTFAIL)
        function("${test_dir_nonexistant}")

            InstalledTarget(CTOR tgt_obj "${CMAKE_CURRENT_SOURCE_DIR}/nonexistant")
        
        endfunction()

    endfunction()

endfunction()
