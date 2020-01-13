include_guard()

if("${CMAKE_BINARY_DIR}" STREQUAL "${CMAKE_CURRENT_SOURCE_DIR}")
    set(_msg "The build directory (${CMAKE_BINARY_DIR}) is the same as the ")
    string(APPEND _msg "current source directory (${CMAKE_CURRENT_SOURCE_DIR})")
    string(APPEND _msg ". This usually means you are attempting to build in ")
    string(APPEND _msg "source, which is strongly discouraged. Please rerun ")
    string(APPEND _msg "cmake with a build directory (use the -B flag) and ")
    string(APPEND _msg "delete ${CMAKE_CURRENT_SOURCE_DIR}/CMakeCache.txt ")
    string(APPEND _msg "which was created when you ran cmake in source.")
    message(FATAL_ERROR "${_msg}")
endif()

# Include the fetch module and bring CMakePPCore into scope
include(cpp/fetch/fetch)
cpp_fetch_cmake_module(
    cmakepp_core
    GIT_REPOSITORY https://github.com/CMakePP/CMakePPCore
)

# Now bring the rest of our modules into scope (they now can use CMakePPCore)
include(cpp/targets/targets)
include(cpp/user_api/user_api)
