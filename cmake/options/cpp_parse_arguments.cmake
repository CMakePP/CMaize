include_guard()
include(options/cpp_kwargs_handle_unparsed)
include(options/cpp_kwargs_unique)

## Function for parsing the kwargs given to a CPP function.
#
# This function wraps the CMake function ``cmake_parse_arguments`` and makes it
# more user-friendly. The biggest addition is more error checking. This
# includes erroring if:
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
# Our wrapper function also guarantees that toggles that are not set are set to
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
function(cpp_parse_arguments _cpa_prefix _cpa_argn)
    set(_cpa_M_kwargs TOGGLES OPTIONS LISTS MUST_SET)
    #Make sure the user didn't specify our kwargs multiple times
    _cpp_kwargs_unique("${_cpa_M_kwargs}" "${ARGN}")

    #Get the keywords the user wants us to parse, error if user provided a kwarg
    #we don't recognize
    cmake_parse_arguments(_cpa "" "" "${_cpa_M_kwargs}" "${ARGN}")
    _cpp_kwargs_handle_unparsed("${_cpa_UNPARSED_ARGUMENTS}")

    #Now that we have the user's kwargs make sure they weren't specified 2x
    foreach(_cpa_kwarg_set ${_cpa_M_kwargs}) #Loop over the types of kwargs
        #This identifier holds the set of user provided kwargs for this type
        set(_cpa_variable _cpa_${_cpa_kwarg_set})
        set(_cpa_value "${${_cpa_variable}}") #This is the list of user kwargs
        #_cpp_kwargs_unique("${_cpa_value}" "${_cpa_argn}")
    endforeach()

    #Parse the argn given to us using the user's kwargs
    cmake_parse_arguments(
       ${_cpa_prefix}
       "${_cpa_TOGGLES}"
       "${_cpa_OPTIONS}"
       "${_cpa_LISTS}"
       "${_cpa_argn}"
    )

    #Ensure required variables are set
    foreach(_cpa_option_i ${_cpa_MUST_SET})
        set(_cpa_var ${_cpa_prefix}_${_cpa_option_i})
        _cpp_is_empty(_cpa_not_set ${_cpa_var})
        if(_cpa_not_set)
            _cpp_error("Required option ${_cpa_var} is not set")
        endif()
    endforeach()

    #Forward the results
    foreach(_cpa_category TOGGLES OPTIONS LISTS)
        foreach(_cpa_option_i ${_cpa_${_cpa_category}})
            set(_cpa_var ${_cpa_prefix}_${_cpa_option_i})
            set(${_cpa_var} "${${_cpa_var}}" PARENT_SCOPE)
        endforeach()
    endforeach()
    set(
        ${_cpa_prefix}_UNPARSED_ARGUMENTS
        ${${_cpa_prefix}_UNPARSED_ARGUMENTS}
        PARENT_SCOPE
    )
endfunction()
