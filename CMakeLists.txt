cmake_minimum_required(VERSION 3.14) # b/c of FetchContent_MakeAvailable
project(CMakePP VERSION 1.0.0)

list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)

option(BUILD_TESTING "Should we build and run the unit tests?" FALSE)
if("${BUILD_TESTING}")
    include(CTest)
    add_subdirectory(tests)
endif()
