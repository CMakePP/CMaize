include_guard()

include(cmaize/user_api/add_executable)

function(cpp_add_tests _cat_test_name)

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

endfunction()

function(cmaize_add_tests _cat_test_name)

    include(CTest)
    cmaize_add_executable("${_cat_test_name}" ${ARGN})
    add_test(NAME "${_cat_test_name}" COMMAND "${_cat_test_name}")

endfunction()
