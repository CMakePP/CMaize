include_guard()

include(logic/is_not_directory)
include(utility/assert_no_extra_args)
include(utility/set_return)

## Generates a new, randomly named directory at the specified path
#
# Particularly for testing purposes we often need to generate a directory to
# store stuff in that doesn't conflict with other directories. This function
# generates a new randomly named directory in the requested directory.
#
# :param result: An identifier to hold the resulting path.
# :param prefix: The directory to create the random directory in.
function(_cpp_random_dir _crd_result _crd_prefix)
    _cpp_assert_no_extra_args("${ARGN}")
    while(TRUE)
        string(RANDOM _crd_suffix)
        set(_crd_dir "${_crd_prefix}/${_crd_suffix}")
        _cpp_is_not_directory(_crd_good "${_crd_dir}")
        if(_crd_good)
            break()
        endif()
    endwhile()
    file(MAKE_DIRECTORY ${_crd_dir})
    _cpp_set_return(${_crd_result} ${_crd_dir})
endfunction()
