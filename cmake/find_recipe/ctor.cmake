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
include(find_recipe/ctor_add_kwargs)
include(object/object)
include(string/cpp_string_cases)
include(utility/set_return)

## Base class for recipes aiming to find dependencies.
#
# :Members:
#
#   * name - The name of the dependency as it should be passed to ``find_package``
#   * version - The version of the dependency we are looking for.
#   * components - Which components of the dependency are we looking for?
#   * root - Where the user told us to look via ``xxx_ROOT``.
#   * paths - Once found the list of paths needed to find the dependency
#   * found - A flag indicating whether or not the dependency has been found.
#
# .. note::
#
#     The contents of the ``paths`` member is not necessarilly the smallest set
#     of paths required to find the dependency. Typically this member contains
#     the contents of ``CMAKE_PREFIX_PATH`` as well as any hints provided to us
#     such as from the cache or from ``xxx_ROOT`` variables. Basically, once we
#     find a dependency we dump all paths that could possibly have been used to
#     find it into this variable with the hope that if later we set
#     ``CMAKE_PREFIX_PATH`` to the contents of this member we can find the
#     dependency again.
#
# :param handle: An identifier to store the handle to the created object
# :param kwags: A handle to the kwargs the ctor should use
#
# :CMake Variables:
#
#   * *<Name>_ROOT* - Here ``<Name>`` matches the capitalization of the ``name``
#     variable.
#   * *<NAME>_ROOT* - Here ``<NAME>`` is the value of the ``name`` variable in
#     all capital letters.
#   * *<name>_ROOT* - Here ``<name>`` is the value of the ``name`` variable in
#     all lowercase letters.
function(_cpp_FindRecipe_ctor _cFc_handle _cFc_kwargs)
    _cpp_FindRecipe_ctor_add_kwargs(${_cFc_kwargs})
    _cpp_Kwargs_parse_argn(${_cFc_kwargs} ${ARGN})
    _cpp_Kwargs_kwarg_value(${_cFc_kwargs} _cFc_name NAME)
    _cpp_Kwargs_kwarg_value(${_cFc_kwargs} _cFc_version VERSION)
    _cpp_Kwargs_kwarg_value(${_cFc_kwargs} _cFc_comps COMPONENTS)
    _cpp_Kwargs_kwarg_value(${_cFc_kwargs} _cFc_depends DEPENDS)

    _cpp_is_empty(_cFc_name_not_set _cFc_name)
    if(_cFc_name_not_set)
        _cpp_error("Dependency name must be set.")
    endif()
    cpp_option(_cFc_version "latest")

    _cpp_Object_ctor(_cFc_temp)
    _cpp_Object_set_type(${_cFc_temp} FindRecipe)
    _cpp_Object_add_members(
        ${_cFc_temp} name version components root paths depends found
    )
    _cpp_Object_set_value(${_cFc_temp} name "${_cFc_name}")
    _cpp_Object_set_value(${_cFc_temp} version "${_cFc_version}")
    _cpp_Object_set_value(${_cFc_temp} components "${_cFc_comps}")
    _cpp_Object_set_value(${_cFc_temp} depends "${_cFc_depends}")
    _cpp_Object_set_value(${_cFc_temp} found FALSE)

    #Look for xxx_ROOT
    _cpp_string_cases(_cFc_cases "${_cFc_name}")
    foreach(_cFc_case_i ${_cFc_cases})
        _cpp_is_not_empty(_cFc_root_set ${_cFc_case_i}_ROOT)
        if(_cFc_root_set)
            _cpp_Object_set_value(${_cFc_temp} root "${${_cFc_case_i}_ROOT}")
            break()
        endif()
    endforeach()

    _cpp_set_return(${_cFc_handle} ${_cFc_temp})
endfunction()
