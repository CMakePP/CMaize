include(cmake_test/cmake_test)

#[[[
# Test the ``CXXTarget`` class.
#]]
ct_add_test(NAME "test_cxx_target")
function("${test_cxx_target}")
    include(cmaize/targets/cxx_target)

    ct_add_section(NAME "creating_new_tgt")
    function("${creating_new_tgt}")

        #[[[
        # Tests to make sure that the ctor enables the CXX language if
        # it has not yet been enabled when the target is created.
        #]]
        ct_add_section(NAME "enables_cxx_language")
        function("${enables_cxx_language}")

            get_property(languages GLOBAL PROPERTY ENABLED_LANGUAGES)

            # CXX shouldn't be enabled in the testing project
            set(cxx_enabled FALSE)
            if ("CXX" IN_LIST languages)
                set(cxx_enabled TRUE)
            endif()
            ct_assert_equal(cxx_enabled FALSE)

            CXXTarget(CTOR tgt_obj "test_target")

            # Now CXX should be enabled (assuming CXX is possible on the machine)
            if(NOT "${CMAKE_CXX_COMPILER}" STREQUAL "")
                set(cxx_enabled TRUE)
            endif()

            ct_assert_equal(cxx_enabled TRUE)

        endfunction()

    endfunction()

    ct_add_section(NAME "test__access_level")
    function("${test__access_level}")

        CXXTarget(CTOR tgt_obj "test_target")

        CXXTarget(_access_level "${tgt_obj}" access_level)

        ct_assert_equal(access_level PUBLIC)

    endfunction()

    #[[[
    # Test ``CXXTarget(_set_compile_features`` method.
    #]]
    # ct_add_section(NAME "test__set_compile_features")
    # function("${test__set_compile_features}")

    #     set(corr "cxx_std_98")

    #     set(tgt_name "test_cxx_target__set_compile_features")
    #     check_language(CXX)
    #     if(CMAKE_CXX_COMPILER)
    #         enable_language(CXX)
    #     else()
    #         message(STATUS "No CXX support")
    #     endif()
    #     add_library("${tgt_name}")

    #     CXXTarget(CTOR tgt_obj "${tgt_name}")

    #     CXXTarget(SET "${tgt_obj}" cxx_standard "${corr}")

    #     CXXTarget(_set_compile_features "${tgt_obj}")

    #     CXXTarget(get_property "${tgt_obj}" standard CXX_STANDARD)

    #     message("-- standard: ${standard}")

    #     ct_assert_equal(standard "${corr}")

    # endfunction()

endfunction()
