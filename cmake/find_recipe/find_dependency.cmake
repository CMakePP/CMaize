################################################################################
#                        Copyright 2018 Ryan M. Richard                        #
#       Licensed under the Apache License, Version 2.0 (the "License");        #
#       you may not use this file except in compliance with the License.       #
#                   You may obtain a copy of the License at                    #
#                                                                              #
#                  http://www.apache.org/licenses/LICENSE-2.0                  #
#                                                                              #
#     Unless required by applicable law or agreed to in writing, software      #
#      distributed under the License is distributed on an "AS IS" BASIS,       #
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.   #
#     See the License for the specific language governing permissions and      #
#                        limitations under the License.                        #
################################################################################

include_guard()
include(logic/negate)
include(object/object)
include(find_recipe/find_from_module/find_from_module)
include(find_recipe/find_from_config/find_from_config)

## Base implementation of find_dependency
#
# This function is responsible for launching the find recipe. It ultimately
# dispatches to the derived class's ``find_dependency`` member function after
# properly accounting for whether or not ``xxx_ROOT`` was set by the user.
#
# :param handle: A handle to a FindRecipe object detailing the search params.
# :param hints: A list of additional places to look for the dependency.
function(_cpp_FindRecipe_find_dependency _cFfd_handle _cFfd_hints)
    #Preprocess the version/components for find_package
    _cpp_Object_get_value(${_cFfd_handle} _cFfd_version version)
    _cpp_are_not_equal(_cFfd_version_set "${_cFfd_version}" "latest")
    if(_cFfd_version_set)
        set(_cFfd_version "VERSION ${_cFfd_version}")
    else()
        set(_cFfd_version "")
    endif()

    _cpp_Object_get_value(${_cFfd_handle} _cFfd_comps components)
    _cpp_is_not_empty(_cFfd_has_comps _cFfd_comps)
    if(_cFfd_has_comps)
        set(_cFfd_comps "COMPONENTS ${_cFfd_comps}")
    else()
        set(_cFfd_comps "")
    endif()

    #Honor xxx_ROOT if set
    _cpp_Object_get_value(${_cFfd_handle} _cFfd_root root)
    _cpp_is_not_empty(_cFfd_root_set _cFfd_root)
    if(_cFfd_root_set)
        set(_cFfd_hints "${_cFfd_root}" "${_cFfd_hints}")
    endif()

    #Dispatch to derived class
    _cpp_Object_has_base(${_cFfd_handle} _cFfd_is_config FindFromConfig)
    _cpp_Object_has_base(${_cFfd_handle} _cFfd_is_module FindFromModule)
    if(_cFfd_is_config)
        _cpp_FindFromConfig_find_dependency(
            ${_cFfd_handle} "${_cFfd_version}" "${_cFfd_comps}" "${_cFfd_hints}"
        )
    elseif(_cFfd_is_module)
        _cpp_FindFromModule_find_dependency(
            ${_cFfd_handle} "${_cFfd_version}" "${_cFfd_comps}" "${_cFfd_hints}"
        )
    endif()

    if(_cFfd_root_set)
        _cpp_Object_get_value(${_cFfd_handle} _cFfd_found found)
        _cpp_Object_get_value(${_cFfd_handle} _cFfd_name name)
        _cpp_negate(_cFfd_found "${_cFfd_found}")
        if("${_cFfd_found}")
            _cpp_error("${_cFfd_name}_ROOT was set to ${_cFfd_root}, but "
                       "${_cFfd_name} was not found.")
        endif()
    endif()
endfunction()
