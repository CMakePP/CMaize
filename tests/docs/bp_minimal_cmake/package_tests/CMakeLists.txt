
cmake_minimum_required(VERSION 3.5)
project(test_bp_minimal_cmake VERSION 1.0.0)
find_package(
    hello_world 1.0.0
    CONFIG
    HINTS ${INSTALL_LOCATION}
    NO_DEFAULT_PATH
    REQUIRED
)

include(CTest)
enable_testing()
add_test(
    NAME "can_run_the_imported_hello_world"
    COMMAND hello_world::hello_world
)
