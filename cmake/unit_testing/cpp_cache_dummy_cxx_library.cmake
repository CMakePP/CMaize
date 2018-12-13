#######################################/home/jboschen/nwx/dev/TAMM/cmake/FindGlobalArrays.cmak#########################################
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
include(cache/cache_add_dependency)

## Wrapper function for writing the recipes for a dummy C++ library
#
# For a dummy C++ library generated with the :ref:`cpp_dummy_cxx_library-label`
# function, this function will write the appropriate recipes to the cache.
#
# :param cache: The CPP cache to write the recipes to.
# :param path: The path provided to the ``_cpp_dummy_cxx_library`` function.
function(_cpp_cache_dummy_cxx_library _ccdcl_cache _ccdcl_path)
    set(_ccdcl_name dummy)
    set(_ccdcl_src ${_ccdcl_path}/${_ccdcl_name})
    _cpp_cache_write_get_recipe(
        ${_ccdcl_cache} ${_ccdcl_name} "" "" "" ${_ccdcl_src}
    )
    _cpp_cache_write_find_recipe(${_ccdcl_cache} ${_ccdcl_name} "")
    _cpp_cache_write_build_recipe(${_ccdcl_cache} ${_ccdcl_name} "" "")
endfunction()
