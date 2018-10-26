include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers.cmake)
include(cpp_dependency)
include(cpp_assert)
set(CPP_DEBUG_MODE ON)
_cpp_setup_build_env("get_remote_dependency")

#We're going to do checks off our our repo
set(gh_repo "github.com/CMakePackagingProject/CMakePackagingProject")

#The successful unpacking of our repo is checked by asserting that our files are
#there
function(validate_result _cpp_vr_dir)
    set(_cpp_comps bin cmake CMakeLists.txt cpp-config.cmake.in Jenkinsfile
                   LICENSE README.md tests
    )
    foreach(_vr_comp ${_cpp_comps})
        _cpp_assert_exists(${_cpp_vr_dir}/${_vr_comp})
    endforeach()
endfunction()

################################################################################
# Test basic usage
################################################################################

_cpp_get_remote_dependency(
    URL "${gh_repo}"
    DOWNLOAD_DIR ${test_prefix}/test1
)
validate_result(${test_prefix}/test1)

################################################################################
# Fails if URL is not specified
################################################################################

_cpp_test_build_fails(
        NAME test
        PATH ${test_prefix}/test
        CONTENTS "include(cpp_dependency)
             _cpp_get_remote_dependency(test)"
        REASON "_cgrd_URL is set to false value:"
)

################################################################################
# Fails if DOWNLOAD_DIR is not specified
################################################################################

_cpp_test_build_fails(
        NAME test
        PATH ${test_prefix}/test
        CONTENTS "include(cpp_dependency)
             _cpp_get_remote_dependency(test URL ${gh_repo})"
        REASON "_cgrd_DOWNLOAD_DIR is set to false value:"
)
