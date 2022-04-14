include(FetchContent)

FetchContent_Declare(
    cmake_test
    GIT_REPOSITORY https://github.com/CMakePP/CMakeTest
)
set(build_testing_old "${BUILD_TESTING}")
set(BUILD_TESTING OFF CACHE BOOL "" FORCE)
FetchContent_MakeAvailable(cmake_test)
include(cmake_test/cmake_test)

set(BUILD_TESTING "${build_testing_old}" CACHE BOOL "" FORCE)

ct_add_dir("cpp")
# ct_add_dir("cpp/targets")
# ct_add_dir("cpp/user_api")

# include(cpp/fetch/fetch_and_available)

# set(build_testing_old "${BUILD_TESTING}")
# set(BUILD_TESTING OFF CACHE BOOL "" FORCE)
# cpp_fetch_and_available(
#     cmake_test
#     GIT_REPOSITORY https://github.com/CMakePP/CMakeTest
# )
# list(APPEND CMAKE_MODULE_PATH "${cmake_test_SOURCE_DIR}")
# SET(BUILD_TESTING "${build_testing_old}" CACHE BOOL "" FORCE)

# # Define a function to make it easier to add tests to CTest
# function(add_cmake_unit_tests prefix)
#     string(REGEX REPLACE ";" "\\\;" test_path "${CMAKE_MODULE_PATH}")
#     foreach(testi ${ARGN})
#         set(full_path ${CMAKE_CURRENT_LIST_DIR}/${testi}.cmake)
#         add_test(
#                 NAME "${prefix}:${testi}"
#                 COMMAND ${CMAKE_COMMAND}
#                 -DCMAKE_MODULE_PATH=${test_path} -P ${full_path}
#         )
#     endforeach()
# endfunction()

# add_subdirectory(targets)
# add_subdirectory(user_api)
