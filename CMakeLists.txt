cmake_minimum_required(VERSION 3.19) # b/c of file(REAL_PATH
project(CMaize VERSION 1.0.0 LANGUAGES NONE)

option(BUILD_TESTING "Should we build and run the unit tests?" OFF)

# If cmake/ directory is not part of the CMAKE_MODULE_PATH, add it so we can
# find CMaize
list(FIND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake" path_has_cmake)
if(${path_has_cmake} STREQUAL "-1")
    list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
endif()

#TODO: When we have support for CMake targets use a package manager...
include(FetchContent)
set(build_testing_old "${BUILD_TESTING}")
set(BUILD_TESTING OFF CACHE BOOL "" FORCE)
FetchContent_Declare(
    cmakepp_lang
    GIT_REPOSITORY https://github.com/CMakePP/CMakePPLang
    GIT_TAG v1.0.4
)
FetchContent_MakeAvailable(cmakepp_lang)
set(BUILD_TESTING "${build_testing_old}" CACHE BOOL "" FORCE)

# For projects including CMaize via FetchContent
if(NOT CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME)
    set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}" PARENT_SCOPE)
endif()


if("${BUILD_TESTING}")
    include(CTest)
    add_subdirectory(tests)
endif()
