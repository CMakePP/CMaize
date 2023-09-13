# Copyright 2023 CMakePP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

include_guard()
include(cmakepp_lang/cmakepp_lang)

cpp_class(CXXTarget)

    cpp_attr(CXXTarget cxx_standard 17)

    cpp_attr(CXXTarget depends)

    cpp_attr(CXXTarget include_dir)

    cpp_attr(CXXTarget includes)

    cpp_attr(CXXTarget name)

    cpp_attr(CXXTarget source_dir)

    cpp_attr(CXXTarget sources)

    cpp_member(_access_level CXXTarget desc)
    function("${_access_level}" _al_this _al_result)
        set("${_al_result}" PUBLIC PARENT_SCOPE)
    endfunction()

    cpp_member(_create_target CXXTarget)
    function("${_create_target}" _ct_this)
        message(FATAL_ERROR "_create_target is pure virtual")
    endfunction()

    cpp_member(_set_include_dir CXXTarget)
    function("${_set_include_dir}" _sid_this)
        CXXTarget(GET "${_sid_this}" _sid_name name)
        CXXTarget(GET "${_sid_this}" _sid_inc_dir include_dir)
        CXXTarget(_access_level "${_sid_this}" _sid_access)
        target_include_directories(
                "${_sid_name}"
                "${_sid_access}"
                $<BUILD_INTERFACE:${_sid_inc_dir}>
                $<INSTALL_INTERFACE:include>
        )
    endfunction()

    cpp_member(_set_compile_features CXXTarget)
    function("${_set_compile_features}" _scf_this)
        CXXTarget(GET "${_scf_this}" _scf_name name)
        CXXTarget(GET "${_scf_this}" _scf_cxx cxx_standard)
        CXXTarget(_access_level "${_scf_this}" _scf_access)
        target_compile_features(
            "${_scf_name}" "${_scf_access}" cxx_std_${_scf_cxx}
        )
    endfunction()

    cpp_member(_set_public_headers CXXTarget)
    function("${_set_public_headers}" _sph_this)
        CXXTarget(GET "${_sph_this}" _sph_name name)
        CXXTarget(GET "${_sph_this}" _sph_incs includes)
        set_target_properties(
                "${_sph_name}" PROPERTIES PUBLIC_HEADER "${_sph_incs}"
        )
    endfunction()

    cpp_member(_set_link_libraries CXXTarget)
    function("${_set_link_libraries}" _sll_this)
        CXXTarget(GET "${_sll_this}" _sll_name name)
        CXXTarget(GET "${_sll_this}" _sll_depends depends)
        CXXTarget(_access_level "${_sll_this}" _sll_access)
        foreach(_sll_depend_i ${_sll_depends})
            cpp_get_global(_sll_helper "_CPP_DEPENDENCY_${_sll_depend_i}__")
            if("${_sll_helper}" STREQUAL "")  # Assume it is a CMake target
                target_link_libraries(
                    "${_sll_name}" "${_sll_access}" "${_sll_depend_i}"
                )
            else()
                Dependency(GET "${_sll_helper}" _sll_target target)
                target_link_libraries(
                    "${_sll_name}" "${_sll_access}" "${_sll_target}"
                )
            endif()
        endforeach()
    endfunction()

    cpp_member(make_target CXXTarget args)
    function("${make_target}" _mt_this)
        set(_mt_options CXX_STANDARD INCLUDE_DIR NAME SOURCE_DIR)
        set(_mt_lists DEPENDS INCLUDES SOURCES)
        cmake_parse_arguments(_mt "" "${_mt_options}" "${_mt_lists}" ${ARGN})

        CXXTarget(SET "${_mt_this}" name "${_mt_NAME}")

        foreach(_mt_option_i CXX_STANDARD DEPENDS INCLUDES NAME SOURCES)
            if(NOT "${_mt_${_mt_option_i}}" STREQUAL "")
                string(TOLOWER "${_mt_option_i}" _mt_lc_option)
                CXXTarget(
                    SET "${_mt_this}"
                    "${_mt_lc_option}" "${_mt_${_mt_option_i}}"
                )
            endif()
        endforeach()

        if(NOT "${_mt_INCLUDE_DIR}" STREQUAL "")
            get_filename_component(_mt_inc_dir "${_mt_INCLUDE_DIR}" DIRECTORY)
            CXXTarget(SET "${_mt_this}" include_dir "${_mt_inc_dir}")
        endif()

        CXXTarget(_CREATE_TARGET "${_mt_this}")
        CXXTarget(_SET_COMPILE_FEATURES "${_mt_this}")
        CXXTarget(_SET_INCLUDE_DIR "${_mt_this}")
        CXXTarget(_SET_LINK_LIBRARIES "${_mt_this}")
        CXXTarget(_SET_PUBLIC_HEADERS "${_mt_this}")
    endfunction()

cpp_end_class()
