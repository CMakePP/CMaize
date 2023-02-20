include_guard()
include(cmakepp_lang/cmakepp_lang)

#[[[ Ensures that the specified dependency's target exists.
#
# This function will assert that the build or find target exists. If the target
# does not exist this function will raise an informative error.
#
# :param _dct_name: The Dependency we are handling
# :type _dct_name: Dependency
# :param _dct_type: Either "build" or "find" depending on whether we are
#                   building or finding the dependency.
# :type _dct_type: desc
#
# :raises TargetNotFound: Given dependency target does not exist.
#]]
function(_cmaize_dependency_check_target _dct_this _dct_type)

    # Verify that the given target exists
    Dependency(GET "${_dct_this}" _dct_target "${_dct_type}_target")
    if(TARGET "${_dct_target}")
        Dependency(SET "${_dct_this}" target "${_dct_target}")
        return()
    endif()

    # Target doesn't exist. Craft an error message and throw an exception
    Dependency(GET "${_dct_this}" _dct_name name)

    set(_dct_msg "Target ${_dct_target} does not exist. Please ensure that")
    string(APPEND _dct_msg " BUILD_TARGET is set to the name of the target")
    string(APPEND _dct_msg " set in the add_library/add_executable command")
    string(APPEND _dct_msg " and that FIND_TARGET is set to the name of the")
    string(APPEND _dct_msg " target set in ${_dct_name}Config.cmake.")

    cpp_raise(TargetNotFound "${_dct_msg}")

endfunction()
