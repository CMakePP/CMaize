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

function(_cpp_BuildRecipe_ctor_add_kwargs _cFcak_kwargs)
    _cpp_Kwargs_add_keywords(
        ${_cFcak_kwargs}
        OPTIONS NAME VERSION SOURCE_DIR TOOLCHAIN
        LISTS CMAKE_ARGS DEPENDS
    )
    _cpp_Kwargs_set_default(
       ${_cFcak_kwargs} TOOLCHAIN "${CMAKE_TOOLCHAIN_FILE}"
    )
    _cpp_Kwargs_set_default(${_cFcak_kwargs} VERSION "latest")
endfunction()
