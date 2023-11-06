# Get a prefix for this run which won't clash with previous runs
string(TIMESTAMP test_prefix)

# Append it to the build directory
set(test_build_dir "${CMAKE_BINARY_DIR}/${test_prefix}")
set(install_build_dir "${test_build_dir}-install")

# Configure
execute_process(
    COMMAND ${CMAKE_COMMAND} -H${TEST_NAME}
                             -B${test_build_dir}
                             -DCMAKE_INSTALL_PREFIX=${install_build_dir}
    COMMAND_ERROR_IS_FATAL ANY
)

# Build
execute_process(
    COMMAND ${CMAKE_COMMAND} --build ${test_build_dir}
    COMMAND_ERROR_IS_FATAL ANY
)

# Test
execute_process(
    COMMAND ${CMAKE_COMMAND} --build ${test_build_dir} -t test
    COMMAND_ERROR_IS_FATAL ANY
)

if(NO_INSTALL)
    return()
endif()

# Install
execute_process(
    COMMAND ${CMAKE_COMMAND} --build ${test_build_dir} -t install
    COMMAND_ERROR_IS_FATAL ANY
)
