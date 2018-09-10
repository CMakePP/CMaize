cmake_minimum_required(VERSION 3.6)
project(CMakePackagingProject VERSION 0.0.0)
set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)
include(CPPMain)
include(cpp_options)
CPPMain()

cpp_option(BUILD_TESTS TRUE)

if(BUILD_TESTS)
    enable_testing()
    add_subdirectory(tests)
endif()

install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/cmake
        DESTINATION ${CPP_SHAREDIR})
