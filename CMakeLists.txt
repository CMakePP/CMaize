cmake_minimum_required(VERSION 3.14) # b/c of FetchContent_MakeAvailable
project(CMakePP VERSION 1.0.0)

list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR})
include(cpp/fetch/cmake_module)
cpp_fetch_cmake_module(
    cmakepp_core
    GIT_REPOSITORY https://github.com/CMakePP/CMakePPCore
)

option(BUILD_TESTS "Should we build and run the unit tests?" FALSE)
if(BUILD_TESTS)
    enable_testing()
    add_subdirectory(tests)
endif()
