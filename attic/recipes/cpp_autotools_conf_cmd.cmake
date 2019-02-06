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

include(toolchain/cpp_toolchain_get)
include(toolchain/cpp_toolchain_contains)

function(_cpp_autotools_conf_cmd _cacc_output _cacc_install _cacc_src _cacc_tc
                                 _cacc_args)
    set(_cacc_conf_cmd ${_cacc_src}/configure)

    _cpp_toolchain_contains(_cacc_has_cxx ${_cacc_tc} CMAKE_CXX_COMPILER)
    if(_cacc_has_cxx)
        _cpp_toolchain_get(_cacc_cxx ${_cacc_tc} CMAKE_CXX_COMPILER)
        set(_cacc_ac_cxx "CXX=${_cacc_cxx}")
    endif()

    _cpp_toolchain_contains(_cacc_has_c ${_cacc_tc} CMAKE_C_COMPILER)
    if(_cacc_has_c)
        _cpp_toolchain_get(_cacc_c ${_cacc_tc} CMAKE_C_COMPILER)
        set(_cacc_ac_c "CC=${_cacc_c}")
    endif()

    set(_cacc_compilers "${_cacc_ac_cxx} ${_cacc_ac_c}")

    if(CMAKE_POSITION_INDEPENDENT_CODE)
        _cpp_is_not_empty(_cacc_have_cxx _cacc_ac_cxx)
        if(_cacc_have_cxx)
            set(_cacc_cxx_flags "CXXFLAGS=-fPIC")
        endif()
        _cpp_is_not_empty(_cacc_have_c _cacc_ac_c)
        if(_cacc_have_c)
            set(_cacc_c_flags "CFLAGS=-fPIC")
        endif()
    endif()

    set(_cacc_flags "${_cacc_cxx_flags} ${_cacc_c_flags}")
    set(_cacc_options "--prefix=${_cacc_install}")
    foreach(_cacc_arg_i ${_cacc_args})
        set(_cacc_options "${_cacc_options} --${_cacc_arg_i}")
    endforeach()

    set(
        ${_cacc_output}
        "${_cacc_conf_cmd} ${_cacc_options} ${_cacc_compilers} ${_cacc_flags}"
        PARENT_SCOPE
    )
endfunction()
