include_guard()
include(cpp_cmake_helpers)
set(test_number 1)


## Function for declaring a test of a CMake function
#
# This function implements what Catch2 would call a section. Basically it
# will run the contents of the test, in the current environment, without
# introducing the test's contents into that environment. In reality what we do
# is dump your test's contents into a CMakeList.txt and run it *via* a sub-cmake
# command. The CMake script that calls this function is treated as the
# equivalent of Catch's test case concept.
#
# .. note::
#
#     Since a kwarg can't appear twice we strive to make our kwargs unique so
#     that they do not conflict with those of the functions we're testing.
#
# :kwargs:
#
#     * *SHOULD_FAIL* (``Toggle``) - Denotes that the test should fail. If the
#       test does not fail, and this toggle is present, the test will be
#       recorded as failed.
#     * *REASON* (``OPTION``) - Used in combination with the *SHOULD_FAIL*
#       toggle to provide the reason the test should fail. This function will
#       assert that the provided text appears in the output of a failed call.
#     * *TITLE* (``OPTION``) - The title of the test.
#
# :CMake Variables:
#
#     * **test_prefix** - Used to get the directory the test is running in.
#     * **test_number** - Used to create the working directory for the specific
#       check. The value will be updated after the call to this function.
#
function(_cpp_add_test)
    cpp_parse_arguments(
        _cat "${ARGN}"
        TOGGLES SHOULD_FAIL
        OPTIONS REASON TITLE
        LISTS CONTENTS
        MUST_SET TITLE
    )
    list(APPEND _cat_CONTENTS ${_cat_UNPARSED_ARGUMENTS})

    if(_cat_SHOULD_FAIL)
        set(_cat_can_fail CAN_FAIL)
    endif()
    foreach(_cat_cmd_i ${_cat_CONTENTS})
        set(_cat_commands "${_cat_commands}\n${_cat_cmd_i}")
    endforeach()
    _cpp_run_sub_build(
        ${test_prefix}/${test_number}
        NAME ${test_number}
        NO_INSTALL
        ${_cat_can_fail}
        RESULT _cat_result
        OUTPUT _cat_output
        CONTENTS "set(CPP_DEBUG_MODE ON)\n${_cat_commands}"
    )

    #Report status to the user
    #We get back 0 if there's no errors so result=true means we had an error
    set(_cat_passed TRUE)
    if(_cat_SHOULD_FAIL)
        if(_cat_result AND _cat_REASON) #Did it crashed for the right reason?
            _cpp_contains(_cat_reason_met "${_cat_REASON}" "${_cat_output}")
            if(NOT _cat_reason_met)
                set(_cat_passed FALSE)
            endif()
        elseif(_cat_result)
            #Okay crashed like it was supposed to, but no reason to check
        else() #Passed, but it wasn't supposed to
            set(_cat_passed FALSE)
        endif()
    endif()

    #Print the result
    set(_cat_result_msg "${_cat_TITLE} ..................")
    if(_cat_passed)
        message("${_cat_result_msg}passed")
    else()
        message("${_cat_result_msg}***failed")
        message(FATAL_ERROR "Output:\n\n${_cat_output}")
    endif()

    math(EXPR test_number "${test_number} + 1")
    set(test_number "${test_number}" PARENT_SCOPE)
endfunction()
