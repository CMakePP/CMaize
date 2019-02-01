include_guard()
include(logic/is_not_empty)

## Asserts that no extra arguments were passed to a function
#
# CMake will automatically check that you pass the minimum number of arguments
# to a funciton; however, CMake will allow you to pass more than the required
# number of arguments to a function. This is a potential error source and this
# function is designed to make it easy to ensure no extra arguments were
# passed. To use it do something like:
#
# .. code-block:: cmake
#
#     include(utility/assert_no_extra_args)
#
#     function(my_fxn arg1 arg2)
#         _cpp_assert_no_extra_args("${ARGN}")
#         # rest of function
#     endfunction()
#
# :param args: The additional arguments passed to your function.
function(_cpp_assert_no_extra_args _canea_args)
    _cpp_is_not_empty(_canea_extra _canea_args)
    if(_canea_extra)
        _cpp_error("Function received extra arguments: ${_canea_args}.")
    endif()
endfunction()
