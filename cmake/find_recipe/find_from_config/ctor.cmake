include_guard()

include(find_recipe/ctor)

## Class holding information for finding a dependency from a CMake config module
#
# Members:
# * config_path - The path to the directoy containing the config file.
#
# :param handle: The identifier that will contain the object.
# :param name: The name of the dependency.
# :param version: The version of the dependency we are looking for.
# :param comps: A list of components that the dependency must have.
function(_cpp_FindFromConfig_ctor _cFc_handle _cFc_name _cFc_version _cFc_comps)
    _cpp_FindRecipe_ctor(
        _cFc_temp "${_cFc_name}" "${_cFc_version}" "${_cFc_components}"
    )
    _cpp_Object_set_type(${_cFc_temp} FindFromConfig)
    _cpp_Object_add_members(${_cFc_temp} config_path)

    #Look for xxx_DIR
    _cpp_string_cases(_cFc_cases "${_cFc_name}")
    foreach(_cFc_case_i ${_cFc_cases})
        _cpp_is_not_empty(_cFc_dir_set ${_cFc_case_i}_DIR)
        if(_cFc_dir_set)
            _cpp_Object_set_value(
                ${_cFc_temp} config_path ${${_cFc_case_i}_DIR}
            )
            break()
        endif()
    endforeach()

    _cpp_set_return(${_cFc_handle} ${_cFc_temp})
endfunction()
