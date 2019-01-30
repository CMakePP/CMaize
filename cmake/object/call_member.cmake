## This function does not work, but starts a function for member dispatching.
#
# Basically the idea is to loop over the types of an object and assume that the
# class ``A`` implements a member function ``fxn`` in a file
# ``${a_root}/fxn.cmake`` where ``${a_root}`` is the directory containing the
# constructor (all ctors would need to be modified to record this). If the file
# exists we include it to bring the member into scope, if it doesn't exist we
# move on to the base class, repeating until we find the function or run out of
# base classes (raising an error in this case). Once we
# find the file we assume that all member functions have the same name and
# forward the arguments to it. We need to somehow figure out which inputs are
# returns so we can return them from this function too (kwargs??)
#
#
function(_cpp_Object_call_member _cOcm_handle _cOcm_fxn)
    #Get a list of types that starts with the most derived and ends with Object
    _cpp_Object_get_value(${_cOcm_handle} _cOcm_types _cpp_type)
    list(REVERSE _cOcm_types)

    #Loop over type list looking for member function file, break when found
    set(_cOcm_inc_file "")
    foreach(_cOcm_type_i ${_cOcm_types})
        _cpp_Object_get_value(
            ${_cOcm_handle} _cOcm_root _cpp_${_cOcm_type_i}_root
        )
        _cpp_exists(_cOcm_overrides "${_cOcm_root}/${_cOcm_fxn}")
        if(_cOcm_overrides)
            set(_cOcm_inc_file "${_cOcm_root}/${_cOcm_fxn}")
            break()
        endif()
    endforeach()

    #Ensure we found a function
    _cpp_is_empty(_cOcm_no_fxn _cOcm_inc_file)
    if(_cOcm_no_fxn)
        _cpp_error("Class does not have a member function ${_cOcm_fxn}")
    endif()

    #Include and call the function
    include(${_cOcm_inc_file})
    _object_member_fxn(${ARGN})

    #Loop over returns and return them from this function
endfunction()
