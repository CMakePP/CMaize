function(sub_cmake_build directory_name)
    set(scb_options NO_INSTALL)
    set(scb_onevalue "")
    set(scb_multivalue "")
    cmake_parse_arguments(scb "${scb_options}" "" "${scb_multivalue}" ${ARGN})

    set(scb_test_dir ${CMAKE_CURRENT_SOURCE_DIR}/${directory_name})
    set(scb_script_name ${CMAKE_CURRENT_SOURCE_DIR}/conf_build_test.cmake)
    set(scb_build_dir ${CMAKE_BINARY_DIR}/tests/docs/${directory_name})

    add_test(
        NAME ${directory_name}
        COMMAND ${CMAKE_COMMAND} -DTEST_NAME=${scb_test_dir}
                                 -DNO_INSTALL=${scb_NO_INSTALL}
                                 -P ${scb_script_name}
                                 -B ${scb_build_dir}
    )
endfunction()

sub_cmake_build(bare_bones_cmake NO_INSTALL)
sub_cmake_build(warning_free_bare_bones NO_INSTALL)
sub_cmake_build(minimal_cmake)
