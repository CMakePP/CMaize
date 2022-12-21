#[[[
# Replaces CMaizeTarget object names with their underlying CMake target
# names in the given list. This function only works with CMaizeTarget
# objects in the current CMaize project.
#
# :param _rpt_result: Return variable.
# :type _rpt_result: desc
# :param args: List of target names.
# :type args: list[desc]
#
# :returns: CMaizeTarget list with target names replaced.
# :rtype: list[desc]
#]]
function(cmaize_replace_project_targets _rpt_result)

    # Assign the given target list to a variable
    set(_rpt_targets ${ARGN})

    # Create a copy target list to replace values in
    set(_rpt_targets_replaced "${_rpt_targets}")

    list(LENGTH _rpt_targets _rpt_targets_len)
    
    # Return blank list if a blank list was given
    if(_rpt_targets_len LESS_EQUAL 0)
        cpp_return("${_rpt_result}")
    endif()

    cpp_get_global(_rpt_project CMAIZE_PROJECT_${PROJECT_NAME})

    # Check if each dependency listed is a CMaizeTarget
    foreach(_rpt_targets_i ${_rpt_targets})
        CMaizeProject(check_target
            "${_rpt_project}" _rpt_tgt_exists "${_rpt_targets_i}"
        )

        # Don't do anything for targets that are not CMaize Targets
        if(NOT _rpt_tgt_exists)
            continue()
        endif()

        CMaizeProject(get_target
            "${_rpt_project}" _rpt_tgt_obj "${_rpt_targets_i}"
        )

        # Get the name of the underlying CMake target
        CMaizeTarget(target "${_rpt_tgt_obj}" _rpt_tgt_name)
        
        # Replace the CMaizeTarget name with the CMake target name
        # This is done while preserving the order of target names
        list(FIND
            _rpt_targets_replaced
            "${_rpt_targets_i}"
            _rpt_tgt_idx
        )
        list(REMOVE_AT _rpt_targets_replaced "${_rpt_tgt_idx}")
        list(INSERT
            _rpt_targets_replaced "${_rpt_tgt_idx}" "${_rpt_tgt_name}"
        )
    endforeach()

    set("${_rpt_result}" "${_rpt_targets_replaced}")
    cpp_return("${_rpt_result}")

endfunction()
