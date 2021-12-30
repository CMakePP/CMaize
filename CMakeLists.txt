cmake_minimum_required(VERSION 3.14) # b/c of FetchContent_MakeAvailable
project(CMaize VERSION 1.0.0 LANGUAGES NONE)

option(BUILD_TESTING "Should we build and run the unit tests?" OFF)

# Include the fetch module and bring CMakePPCore into scope
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
include(cpp/fetch/fetch_and_available)
set(build_testing_old "${BUILD_TESTING}")
set(BUILD_TESTING OFF CACHE BOOL "" FORCE)
cpp_fetch_and_available(
        cmakepp_core
        GIT_REPOSITORY https://github.com/CMakePP/CMakePPCore
)

list(APPEND CMAKE_MODULE_PATH "${cmakepp_core_SOURCE_DIR}/cmake")

set(BUILD_TESTING "${build_testing_old}" CACHE BOOL "" FORCE)

if("${BUILD_TESTING}")
    include(CTest)
    add_subdirectory(tests)
endif()
