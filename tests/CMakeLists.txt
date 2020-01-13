include(cpp/fetch/cmake_module)
cpp_fetch_cmake_module(
    cmake_test
    GIT_REPOSITORY https://github.com/CMakePP/CMakeTest
    GIT_TAG cmakedoc
)

# Define a function to make it easier to add tests to CTest
function(add_cmake_unit_tests prefix)
    string(REGEX REPLACE ";" "\\\;" test_path "${CMAKE_MODULE_PATH}")
    foreach(testi ${ARGN})
        set(full_path ${CMAKE_CURRENT_LIST_DIR}/${testi}.cmake)
        add_test(
                NAME "${prefix}:${testi}"
                COMMAND ${CMAKE_COMMAND}
                -DCMAKE_MODULE_PATH=${test_path} -P ${full_path}
        )
    endforeach()
endfunction()

add_subdirectory(targets)
add_subdirectory(user_api)
