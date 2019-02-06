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
include(cache/add_version)
include(get_recipe/get_recipe)
include(logic/are_equal)
include(logic/does_not_exist)
include(utility/assert_no_extra_args)
include(utility/mkdir_if_dne)
include(utility/random_dir)
include(utility/set_return)

## Adds the tarball to the cache
#
# This function uses the GetRecipe to get the tarball. Then in an ideal world it
# places it in the cache with a name that reflects the dependency and version.
# In practice there may already be a tarball in the cache with that name. If so,
# we hash both tarballs to see if they are the same. If they are the same we
# delete the tarball we obtained and return. Otherwise we
function(_cpp_Cache_save_tarball _cCst_handle _cCst_path _cCst_get_recipe)
    _cpp_Object_get_value(${_cCst_handle} _cCst_root root)
    _cpp_Object_get_value(${_cCst_get_recipe} _cCst_name name)
    _cpp_Object_get_value(${_cCst_get_recipe} _cCst_ver version)

    _cpp_Cache_add_version(
        ${_cCst_handle} _cCst_temp ${_cCst_name} ${_cCst_ver}
    )

    #Get the tarball
    set(_cCst_tar_dir ${_cCst_temp}/tarballs)
    _cpp_mkdir_if_dne(${_cCst_tar_dir})
    set(_cCst_tar ${_cCst_tar_dir}/just_downloaded.tar.gz)
    _cpp_GetRecipe_get_source(${_cCst_get_recipe} ${_cCst_tar})
    file(SHA1 ${_cCst_tar} _cCst_hash)


    #Determine what to call the tarball
    set(_cCst_count 0)
    set(_cCst_tar_name ${_cCst_name}.${_cCst_ver}.tar.gz)
    set(_cCst_guess ${_cCst_tar_dir}/${_cCst_tar_name})
    while(TRUE)
        _cpp_does_not_exist(_cCst_good ${_cCst_guess})
        if(_cCst_good)
            file(RENAME ${_cCst_tar} ${_cCst_guess})
            break()
        endif()
        file(SHA1 ${_cCst_guess} _cCst_other_hash)
        _cpp_are_equal(_cCst_same_tar "${_cCst_other_hash}" "${_cCst_hash}")
        if(_cCst_same_tar)
            break()
        endif()
        math(EXPR _cCst_count "${_cCst_count} + 1")
        set(_cCst_guess ${_cCst_temp}/tarballs/${_cCst_tar_name}.${_cCst_count})
    endwhile()
    _cpp_set_return(${_cCst_path} ${_cCst_guess})
endfunction()
