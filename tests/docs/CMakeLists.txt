function(sub_cmake_build directory_name)
    set(scb_options NO_INSTALL)
    set(scb_onevalue "")
    set(scb_multivalue "CMAKE_ARGS")
    cmake_parse_arguments(scb "${scb_options}" "" "${scb_multivalue}" ${ARGN})

    set(scb_test_dir ${CMAKE_CURRENT_SOURCE_DIR}/${directory_name})
    set(scb_script_name ${CMAKE_CURRENT_SOURCE_DIR}/conf_build_test.cmake)
    set(scb_build_dir ${CMAKE_BINARY_DIR}/tests/docs/${directory_name})
    _message("CMAKE_ARGS: {scb_CMAKE_ARGS}")
    add_test(
        NAME ${directory_name}
        COMMAND ${CMAKE_COMMAND} -DTEST_NAME=${scb_test_dir}
                                 -DNO_INSTALL=${scb_NO_INSTALL}
                                 -DCMAKE_ARGS="${scb_CMAKE_ARGS}"
                                 -P ${scb_script_name}
                                 -B ${scb_build_dir}
    )
endfunction()

# Note that even though the first two build systems are subsets of the third, we
# maintain separate tests because the documentation states that all three build
# systems will work. Should CMake ever decide they don't, we want to know.
sub_cmake_build(bare_bones_cmake NO_INSTALL)
sub_cmake_build(warning_free_bare_bones NO_INSTALL)
sub_cmake_build(minimal_cmake)

# Tests "minimal_cmake" can be included via FetchContent
set(minimal_cmake_src ${CMAKE_CURRENT_SOURCE_DIR}/minimal_cmake)
sub_cmake_build(
    minimum_is_good_with_fc
    NO_INSTALL
    CMAKE_ARGS "-DFETCHCONTENT_SOURCE_DIR_HELLO_WORLD=${minimal_cmake_src}"
)
