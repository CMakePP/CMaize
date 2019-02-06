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
include(cache/save_tarball)
include(utility/set_return)

function(_cpp_Cache_install_dir _cCid_handle _cCid_dir _cCid_get_recipe
         _cCid_build_recipe)
    _cpp_Object_get_value(${_cCid_build_recipe} _cCid_tc toolchain)
    _cpp_Object_get_value(${_cCid_build_recipe} _cCid_args args)
    _cpp_Object_get_value(${_cCid_get_recipe} _cCid_name name)
    _cpp_Object_get_value(${_cCid_get_recipe} _cCid_ver version)

    _cpp_Cache_save_tarball(${_cCid_handle} _cCid_src ${_cCid_get_recipe})
    _cpp_Cache_add_version(
        ${_cCid_handle} _cCid_root ${_cCid_name} ${_cCid_ver}
    )

    file(SHA1 ${_cCid_src} _cCid_hash)
    file(SHA1 ${_cCid_tc} _cCid_tc_hash)
    set(_cCid_temp ${_cCid_root}/install/${_cCid_hash}/${_cCid_tc_hash})
    set(_cCid_arg_file ${_cCid_temp}/args.cmake)
    file(WRITE ${_cCid_arg_file} "${_cCid_args}")
    file(SHA1 ${_cCid_arg_file} _cCid_arg_hash)
    _cpp_mkdir_if_dne(${_cCid_temp}/${_cCid_arg_hash})
    _cpp_set_return(${_cCid_dir} ${_cCid_temp}/${_cCid_arg_hash})
endfunction()
