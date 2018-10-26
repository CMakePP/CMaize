include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers.cmake)
_cpp_setup_build_env("cpp_untar_directory")

#Make some tarballs
_cpp_dummy_cxx_library(${test_prefix}/dummy)
execute_process(
    COMMAND ${CMAKE_COMMAND} -E tar "cfz" "${test_prefix}/good.tar.gz"
            "dummy"
    WORKING_DIRECTORY ${test_prefix}
)
execute_process(
    COMMAND ${CMAKE_COMMAND} -E tar "cfz" "${test_prefix}/empty.tar.gz"
            ""
)
execute_process(
    COMMAND ${CMAKE_COMMAND} -E tar "cfz" "${test_prefix}/bad1.tar.gz"
            "a.hpp"
    WORKING_DIRECTORY ${test_prefix}/dummy
)
execute_process(
    COMMAND ${CMAKE_COMMAND} -E tar "cfz" "${test_prefix}/bad2.tar.gz"
            "a.hpp" "a.cpp"
    WORKING_DIRECTORY ${test_prefix}/dummy
)

set(prefix "_cpp_untar_directory(${test_prefix}")

#Note that test number is actually 1 behind when we tell it where to unpack,
#but since our first test never gets that far it's okay

_cpp_add_test(
TITLE "File DNE"
SHOULD_FAIL REASON "No such file or directory:"
CONTENTS "${prefix}/not_a_tar.tar.gz ${test_prefix}/${test_number})"
)

_cpp_add_test(
TITLE "Fails for empty tar"
SHOULD_FAIL REASON "The tarball was empty"
CONTENTS "${prefix}/empty.tar.gz ${test_prefix}/${test_number})"
)

_cpp_add_test(
TITLE "Fails if tarball contains more than 1 thing"
SHOULD_FAIL REASON "The tarball contained more than 1 thing."
CONTENTS "${prefix}/bad2.tar.gz ${test_prefix}/${test_number})"
)

_cpp_add_test(
TITLE "Fails if tarball does not contain a directory"
SHOULD_FAIL REASON "The tarball does not contain a directory"
CONTENTS "${prefix}/bad1.tar.gz ${test_prefix}/${test_number})"
)

_cpp_add_test(
TITLE "Untars a good directory"
CONTENTS
    "${prefix}/good.tar.gz ${test_prefix}/${test_number})"
    "_cpp_assert_exists(${test_prefix}/${test_number}/a.hpp)"
    "_cpp_assert_exists(${test_prefix}/${test_number}/a.cpp)"
)
