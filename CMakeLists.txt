cmake_minimum_required(VERSION 3.14) # b/c of FetchContent_MakeAvailable
project(CMaize VERSION 1.0.0 LANGUAGES NONE)

option(BUILD_TESTING "Should we build and run the unit tests?" OFF)

# If cmake/ directory is not part of the CMAKE_MODULE_PATH, add it so we can
# find CMaize and CMakePPLang
list(FIND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake" path_has_cmake)
if(${path_has_cmake} STREQUAL "-1")
    list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
endif()

include(cpp/fetch/fetch_and_available)
set(build_testing_old "${BUILD_TESTING}")
set(BUILD_TESTING OFF CACHE BOOL "" FORCE)
cpp_fetch_and_available(
    cmakepp_lang
    GIT_REPOSITORY https://github.com/CMakePP/CMakePPLang
)

#For projects including CMaize via FetchContent
if(NOT CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME)
	set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}" PARENT_SCOPE)
endif()
set(BUILD_TESTING "${build_testing_old}" CACHE BOOL "" FORCE)

if("${BUILD_TESTING}")
    include(CTest)
    add_subdirectory(tests)
endif()
