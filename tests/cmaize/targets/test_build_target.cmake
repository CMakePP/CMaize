include(cmake_test/cmake_test)

#[[[
# Test the ``BuildTarget`` class.
#]]
ct_add_test(NAME "test_build_target")
function("${test_build_target}")
    include(cmaize/targets/build_target)

    #[[[
    # Test ``BuildTarget(make_target`` method.
    #]]
    ct_add_section(NAME "test_make_target")
    function("${test_make_target}")

        ct_add_section(NAME "virtual_throw" EXPECTFAIL)
        function("${virtual_throw}")
            set(tgt_name "test_build_target_make_target_virtual_throw")

            BuildTarget(CTOR tgt_obj "${tgt_name}")

            BuildTarget(make_target "${tgt_obj}")
        endfunction()

    endfunction()

    #[[[
    # Test ``BuildTarget(_create_target`` method.
    #]]
    ct_add_section(NAME "test__create_target")
    function("${test__create_target}")

        ct_add_section(NAME "virtual_throw" EXPECTFAIL)
        function("${virtual_throw}")
            set(tgt_name "test_build_target__create_target_virtual_throw")

            BuildTarget(CTOR tgt_obj "${tgt_name}")

            BuildTarget(_create_target "${tgt_obj}")
        endfunction()

    endfunction()

    #[[[
    # Test ``BuildTarget(_set_include_directories`` method.
    #]]
    ct_add_section(NAME "test__set_include_directories")
    function("${test__set_include_directories}")

        ct_add_section(NAME "virtual_throw" EXPECTFAIL)
        function("${virtual_throw}")
            set(tgt_name "test_build_target__set_include_directories_virtual_throw")

            BuildTarget(CTOR tgt_obj "${tgt_name}")

            BuildTarget(_set_include_directories "${tgt_obj}")
        endfunction()

    endfunction()

endfunction()
