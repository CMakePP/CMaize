include_guard()
include(object/object)

## Provides an object-oriented view of the Cache
#
# Given a directory to use as a cache, this will create a Cache object from that
# directory.
#
# :Members:
#
#   * root - The root directory of the Cache
#   * find_recipes - A list of find recipes stored in the Cache
#   * get_recipes - A list of get recipes stored in the Cache
#   * find_modules - A list of find modules stored in the Cache
#
# :param handle: An identifier to give the handle to.
# :param path: The directory to use as the Cache
function(_cpp_Cache_ctor _cCc_handle _cCc_path)
    _cpp_Object_ctor(_cCc_temp)
    _cpp_Object_set_type(${_cCc_temp} Cache)
    _cpp_Object_add_members(${_cCc_temp} root find_recipes get_recipes
                            find_modules)
    foreach(_cCc_content_i find_recips get_recipes find_modules)
        _cpp_does_not_exist(_cCc_dne ${_cCc_path}/${_cCc_content_i})
        if(_cCc_dne)
            continue()
        endif()

    endforeach()

endfunction()
