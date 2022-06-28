include_guard()

include(cmaize/user_api/add_executable)

#[[[
# User macro to add a set of CTest tests.
#
# .. warning::
#
#    ``cpp_add_tests()`` is depricated. ``cmaize_add_tests()`` should be
#    used to create new tests.
#
# :param _cat_test_name: Name for the test, test executable, and test command.
# :type _cat_test_name: desc
#]]
macro(cpp_add_tests _cat_test_name)

    set(_cat_options INCLUDE_DIR INCLUDE_DIRS)
    cmake_parse_arguments(_cat "" "${_cat_options}" "" ${ARGN})

    # Historically, only INCLUDE_DIR was used, so INCLUDE_DIRS needs to
    # be generated based on the value of INCLUDE_DIR
    list(LENGTH _cat_INCLUDE_DIRS _cat_INCLUDE_DIRS_n)
    if(NOT "${_cat_INCLUDE_DIRS_n}" GREATER 0)
        set(_cat_INCLUDE_DIRS "${_cat_INCLUDE_DIR}")
    endif()

    cmaize_add_tests(
        "${_cat_test_name}"
        INCLUDE_DIRS "${_cat_INCLUDE_DIRS}"
        ${ARGN}
    )

endmacro()

#[[[
# User macro to add a set of CTest tests.
#
# :param _cat_test_name: Name for the test, test executable, and test command.
# :type _cat_test_name: desc
#]]
macro(cmaize_add_tests _cat_test_name)

    include(CTest)
    cmaize_add_executable("${_cat_test_name}" ${ARGN})
    add_test(NAME "${_cat_test_name}" COMMAND "${_cat_test_name}")

endmacro()
