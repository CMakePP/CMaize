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
# :param INCLUDE_DIR: Directory containing files to include.
# :type INCLUDE_DIR: path, optional
# :param INCLUDE_DIRS: Directories containing files to include. If this
#                      parameter is given a value, the value of ``INCLUDE_DIR``
#                      will be ignored.
# :type INCLUDE_DIRS: List[path], optional
#]]
macro(cpp_add_tests _cat_test_name)

    set(_cat_options INCLUDE_DIR)
    set(_cat_lists INCLUDE_DIRS)
    cmake_parse_arguments(_cat "" "${_cat_options}" "${_cat_lists}" ${ARGN})

    # Historically, only INCLUDE_DIR was used, so INCLUDE_DIRS needs to
    # be generated based on the value of INCLUDE_DIR. If INCLUDE_DIRS is
    # provided, INCLUDE_DIR is ignored.
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
# .. note::
#
#    For additional optional parameters related to the specific language
#    used, see the documentation for `cmaize_add_executable()`.
#
# :param _cat_test_name: Name for the test, test executable, and test command.
# :type _cat_test_name: desc
#]]
macro(cmaize_add_tests _cat_test_name)

    include(CTest)
    cmaize_add_executable("${_cat_test_name}" ${ARGN})
    add_test(NAME "${_cat_test_name}" COMMAND "${_cat_test_name}")

endmacro()
