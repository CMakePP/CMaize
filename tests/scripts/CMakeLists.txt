include_guard()

function(_add_integration_test test_name cmd)

    add_test(
        NAME "${test_name}"
        COMMAND ${cmd}
        # WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
    )

endfunction()

# List of tests to be created
list(APPEND test_list
    CMakePublic
    CMaizePublicDepend
    CMaizePublicDepend2
    CMaizePublicDepend2_w_CMaizePublicDepend
    CMaizePublicDepend2_w_CMakePublic
    CMaizePublicDepend2_w_all_deps
    CMakePrivate
    CMaizePrivateDepend
    CMaizePrivateDepend2
    CMaizePrivateDepend2_w_CMaizePrivateDepend
    CMaizePrivateDepend2_w_CMakePrivate
    CMaizePrivateDepend2_w_all_deps
)

# Move all of the test scripts to the build directory
foreach(test_i ${test_list})
    configure_file(
        "${CMAKE_CURRENT_SOURCE_DIR}/test_${test_i}.sh"
        "${CMAKE_CURRENT_BINARY_DIR}/test_${test_i}.sh"
        COPYONLY
    )
endforeach()

configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/toolchain.cmake"
    "${CMAKE_CURRENT_BINARY_DIR}/toolchain.cmake"
    COPYONLY
)
configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/utilities.sh"
    "${CMAKE_CURRENT_BINARY_DIR}/utilities.sh"
    COPYONLY
)

# Create the tests
foreach(test_i ${test_list})
    _add_integration_test(
        "${test_i}"
        "${CMAKE_CURRENT_BINARY_DIR}/test_${test_i}.sh;--clean;${CMAIZE_GITHUB_TOKEN}"
    )
endforeach()

# Label all repo_list tests as integration tests
set_property(
    TEST ${test_list}
    PROPERTY
        LABELS "integration_tests"
)
