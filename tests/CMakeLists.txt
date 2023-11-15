include(FetchContent)

add_subdirectory(scripts)

FetchContent_Declare(
    cmake_test
    GIT_REPOSITORY https://github.com/CMakePP/CMakeTest
)
set(build_testing_old "${BUILD_TESTING}")
set(BUILD_TESTING OFF CACHE BOOL "" FORCE)
FetchContent_MakeAvailable(cmake_test)
include(cmake_test/cmake_test)

set(BUILD_TESTING "${build_testing_old}" CACHE BOOL "" FORCE)

# ct_add_dir("cpp")
ct_add_dir("cmaize")
add_subdirectory(docs)
