include(cmake_test/cmake_test)

#[[[
# Test the ``CXXTarget`` class.
#]]
ct_add_test(NAME "test_cxx_target")
function("${test_cxx_target}")
    include(cmaize/targets/cxx_target)

    ct_add_section(NAME "test__access_level")
    function("${test__access_level}")

        CXXTarget(CTOR tgt_obj "test_target")

        CXXTarget(_access_level "${tgt_obj}" access_level)

        ct_assert_equal(access_level PUBLIC)

    endfunction()

    # #[[[
    # # Test ``CXXTarget(_set_compile_features`` method.
    # #]]
    # ct_add_section(NAME "test__set_compile_features")
    # function("${test__set_compile_features}")

    #     set(std_year "98")
    #     set(corr "cxx_std_${std_year}")

    #     # Create a target
    #     set(tgt_name "test_cxx_target__set_compile_features")
    #     add_library("${tgt_name}")

    #     CXXTarget(CTOR tgt_obj "${tgt_name}")

    #     CXXTarget(SET "${tgt_obj}" cxx_standard "${std_year}")

    #     CXXTarget(_set_compile_features "${tgt_obj}")

    #     # CXXTarget(get_property "${tgt_obj}" standard CXX_STANDARD)
    #     get_target_property(features "${tgt_name}" "COMPILE_FEATURES") # DEBUG
    #     # CXXTarget(get_property "${tgt_obj}" features COMPILE_FEATURES) # DEBUG

    #     message("-- standard: ${standard}")
    #     message("-- compile features: ${features}")

    #     ct_assert_equal(standard "${corr}")

    # endfunction()

    # #[[[
    # # Test ``CXXTarget(_set_include_directories`` method.
    # #]]
    # ct_add_section(NAME "test__set_include_directories")
    # function("${test__set_include_directories}")

    #     ct_add_section(NAME "with_no_directories_set")
    #     function("${with_no_directories_set}")

    #         set(inc_dirs "test")
    #         list(APPEND corr "$<BUILD_INTERFACE:test>")
    #         list(APPEND corr "$<INSTALL_INTERFACE:include>")
    #         # cpp_encode_special_chars(${corr} corr)

    #         # Create a target
    #         set(tgt_name "test_cxx_target__set_include_directories_with_no_directories_set")
    #         add_library("${tgt_name}")

    #         CXXTarget(CTOR tgt_obj "${tgt_name}")
    #         CXXTarget(SET "${tgt_obj}" include_dirs "${inc_dirs}")
    #         CXXTarget(_set_include_directories "${tgt_obj}")

    #         get_target_property(directories "${tgt_name}" INTERFACE_INCLUDE_DIRECTORIES)
    #         message("Correct Directories: ${corr}") # DEBUG
    #         message("Directories: ${directories}") # DEBUG

    #         ct_assert_equal(directories "${corr}")

    #     endfunction()

    # endfunction()

endfunction()
