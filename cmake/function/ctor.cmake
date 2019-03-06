include_guard()
include(object/object)
include(kwargs/kwargs)

## Class responsible for implementing a function
#
#  The Function class is a generic functor that is intended primarily to be used
#  as a member function of an object. The class stores a list of kwargs that the
#  function recognizes and a list of identifiers that will be used for returning
#  variables (at the time of the actual run the caller provides a prefix that
#  will be prepended to each of these variables to avoid name collisions). The
#  class also attempts to take care of some of the error-checking for your
#  function. For example, it will check that all options are set to a value.
#
# :param handle: An identifier to hold the newly created object.
# :param file: The file that holds the definition of the function
#
# :Members:
#
#    * *returns*  - List of identifiers that will be returned by the function.
#    * *kwargs*   - Kwargs object
#    * *this*     - The handle of the object this function belongs to
# :kwargs:
#     * *NO_KWARGS* - A toggle that signals the function takes no kwarg-based
#                     input.
#     * *THIS*      - The handle of the object this function belongs to
#     * *TOGGLES*   - A list of input parameters to the function that should be
#                     treated as toggles.
#     * *OPTIONS*   - A list of inputs that should take a single value.
#     * *LISTS*     - A list of inputs that should take 0 or more values.
#     * *RETURNS*   - A list of identifiers that will be used for returns
function(_cpp_Function_ctor _cFc_handle _cFc_file)
    #---------------------------------------------------------------------------
    #----------------------------Error Checking---------------------------------
    #---------------------------------------------------------------------------
    _cpp_is_empty(_cFc_not_set _cFc_file)
    if(_cFc_not_set)
        _cpp_error("Must provide an implementation file.")
    endif()
    _cpp_does_not_exist(_cFc_dne ${_cFc_file})
    if(_cFc_dne)
        _cpp_error("Function implementation ${_cFc_file} does not exist.")
    endif()

    #---------------------------------------------------------------------------
    #-----------------------Set State Besides KWARGS----------------------------
    #---------------------------------------------------------------------------

    _cpp_Object_ctor(_cFc_temp)
    set(_cFc_toggles NO_KWARGS)
    set(_cFc_options THIS)
    set(_cFc_lists TOGGLES OPTIONS LISTS RETURNS)
    cmake_parse_arguments(
        _cFc "${_cFc_toggles}" "${_cFc_options}" "${_cFc_lists}" ${ARGN}
    )
    _cpp_Object_add_members(${_cFc_temp} returns this file kwargs)
    _cpp_Object_set_value(${_cFc_temp} returns "${_cFc_RETURNS}")
    _cpp_Object_set_value(${_cFc_temp} this "${_cFc_THIS}")
    _cpp_Object_set_value(${_cFc_temp} file ${_cFc_file})

    #---------------------------------------------------------------------------
    #-----------------------------Handle KWARGS---------------------------------
    #---------------------------------------------------------------------------


    #Quit if fxn takes no kwargs, allows Kwargs class to use Function class
    if(_cFc_NO_KWARGS)
        _cpp_set_return(${_cFc_handle} ${_cFc_temp})
        return()
    endif()

    _cpp_Kwargs_ctor(_cFc_kwargs)
    _cpp_Kwargs_add_keywords(
        ${_cFc_kwargs}
        TOGGLES "${_cFc_TOGGLES}"
        OPTIONS "${_cFc_OPTIONS}"
        LISTS   "${_cFc_LISTS}"
    )
    _cpp_Object_set_value(${_cFc_temp} kwargs ${_cFc_kwargs})
    _cpp_set_return(${_cFc_handle} ${_cFc_temp})
endfunction()
