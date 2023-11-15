# Copyright 2023 CMakePP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

include_guard()
include(cmakepp_lang/cmakepp_lang)

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

    cpp_get_global(_rpt_project CMAIZE_TOP_PROJECT)

    # Check if each dependency listed is a CMaizeTarget
    foreach(_rpt_targets_i ${_rpt_targets})
        CMaizeProject(check_target
            "${_rpt_project}" _rpt_tgt_exists "${_rpt_targets_i}" ALL
        )
        
        # Don't do anything for targets that are not CMaize Targets
        if(NOT _rpt_tgt_exists)
            continue()
        endif()

        CMaizeProject(get_target
            "${_rpt_project}" _rpt_tgt_obj "${_rpt_targets_i}" ALL
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
