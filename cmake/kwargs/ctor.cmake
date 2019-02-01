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
include(object/object)
include(kwargs/handle_unparsed)
include(kwargs/unique)
include(utility/set_return)

## Function for parsing the kwargs given to a CPP function.
#
# This function wraps the CMake function ``cmake_parse_arguments`` and makes it
# into a more user-friendly object. Other than being an object, the biggest
# addition is more error checking. This includes erroring if:
#
# - one of our kwargs appears more than once.
# - the user provided us with an unrecognized kwargs
#
#     - We can only catch this if the user provided the unrecognized kwarg
#       before all other kwargs. If they did not it'll get mixed in with the
#       lists.
#
# - one of the user's kwargs appears more than once.
# - if a required kwarg is not set
#
# The Kwargs object also guarantees that toggles that are not set are set to
# false and that it is possible to set an option/list to an empty string. The
# latter enables forwarding of arguments like:
#
# .. code-block:: cmake
#
#     cpp_parse_arguments(_prefix "${ARGN}" OPTIONS OPTION1)
#     a_fxn(OPTION1 "${_prefix_OPTION1}")
#
# without having to worry about whether or not ``_prefix_OPTION1`` was set.
#
# .. note::
#
#     We do **NOT** error if there are unpased arguments in the list of
#     arguments we are parsing on behalf of the user. It is recommended that the
#     user call :ref:`cpp_kwargs_handle_unparsed-label` if their function does
#     not rely on the unparsed arguments in some manner.
#
# :param prefix: The namespace to use for scoping the returns (*e.g.*, setting
#     prefix="_cpa" will result in identifiers like ``_cpa_NAME``).
# :param argn: The list of additional arguments to your function. This should
#     be provided like ``"${ARGN}``.
#
# :kwargs:
#
#     * *TOGGLES* (``list``) - Denotes a list of kwargs that should be parsed as
#       toggles.
#     * *OPTIONS* (``list``) - Denotes a list of kwargs that should be parsed as
#       options.
#     * *LISTS* (``list``) - Denotes a list of kwargs that should be parsed as
#       lists.
#     * *MUST_SET* (``list``) - Denotes a list of kwargs that must contain a
#       value.
function(_cpp_Kwargs_ctor _cKpa_handle _cKpa_argn)
    _cpp_Object_ctor(_cKpa_temp)
    _cpp_Object_set_type(${_cKpa_temp} Kwargs)
    _cpp_Object_add_members(${_cKpa_temp} keys)

    set(_cKpa_M_kwargs TOGGLES OPTIONS LISTS MUST_SET)
    #Make sure the user didn't specify our kwargs multiple times
    _cpp_kwargs_unique("${_cKpa_M_kwargs}" "${ARGN}")

    #Get the keywords the user wants us to parse, error if user provided a kwarg
    #we don't recognize
    cmake_parse_arguments(_cKpa "" "" "${_cKpa_M_kwargs}" "${ARGN}")
    _cpp_kwargs_handle_unparsed("${_cKpa_UNPARSED_ARGUMENTS}")

    #Now that we have the user's kwargs make sure they weren't specified 2x
    foreach(_cKpa_kwarg_set ${_cKpa_M_kwargs}) #Loop over the types of kwargs
        #This identifier holds the set of user provided kwargs for this type
        set(_cKpa_variable _cKpa_${_cKpa_kwarg_set})
        set(_cKpa_value "${${_cKpa_variable}}") #This is the list of user kwargs
        #_cpp_kwargs_unique("${_cpa_value}" "${_cpa_argn}")
    endforeach()

    #Parse the argn given to us using the user's kwargs
    cmake_parse_arguments(
        _cKpa
       "${_cKpa_TOGGLES}"
       "${_cKpa_OPTIONS}"
       "${_cKpa_LISTS}"
       "${_cKpa_argn}"
    )

    #Ensure required variables are set
    foreach(_cKpa_option_i ${_cKpa_MUST_SET})
        set(_cKpa_var _cKpa_${_cKpa_option_i})
        _cpp_is_empty(_cKpa_not_set ${_cKpa_var})
        if(_cKpa_not_set)
            _cpp_error("Required option ${_cKpa_var} is not set")
        endif()
    endforeach()

    #Add them to the object
    set(_cKpa_keys "")
    foreach(_cKpa_category TOGGLES OPTIONS LISTS)
        foreach(_cKpa_option_i ${_cKpa_${_cKpa_category}})
            list(APPEND _cKpa_keys "${_cKpa_option_i}")
            set(_cKpa_value "${_cKpa_${_cKpa_option_i}}")
            set(_cKpa_member kwargs_${_cKpa_option_i})
            _cpp_Object_add_members(${_cKpa_temp} ${_cKpa_member})
            _cpp_Object_set_value(
                ${_cKpa_temp} ${_cKpa_member} "${_cKpa_value}"
            )
        endforeach()
    endforeach()
    _cpp_set_return(CPP_UNPARSED_ARGUMENTS "${_cKpa_UNPARSED_ARGUMENTS}")
    _cpp_set_return("${_cKpa_handle}" "${_cKpa_temp}")
endfunction()
