include_guard()

#[[[ Ensures that the specified dependency's target exists.
#
# This function will assert that the build or find target exists. If the target
# does not exist this function will raise an informative error.
#
# :param _dct_name: The Dependency we are handling
# :type _dct_name: Dependency
# :param _dct_type: Either "build" or "find" depending on whether we are
#                   building or finding the dependency.
# :type _cft_target: desc
#]]
function(_cpp_dependency_check_target _dct_this _dct_type)

    Dependency(GET "${_dct_this}" _dct_target "${_dct_type}_target")
    if(TARGET "${_dct_target}")
        Dependency(SET "${_dct_this}" target "${_dct_target}")
        return()
    endif()

    Dependency(GET "${_dct_this}" _dct_name name)

    set(_dct_msg "Target ${_dct_target} does not exist. Please ensure that ")
    string(APPEND _dct_msg " BUILD_TARGET is set to the name of the target set")
    string(APPEND _dct_msg " in the add_library/add_executable command and ")
    string(APPEND _dct_msg "that FIND_TARGET is set to the name of the target ")
    string(APPEND _dct_msg "set in ${_dct_name}Config.cmake.")

    message(FATAL_ERROR "${_dct_msg}")
endfunction()
