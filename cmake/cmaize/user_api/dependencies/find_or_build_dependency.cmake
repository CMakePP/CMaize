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
include(cmaize/project/cmaize_project)
include(cmaize/user_api/dependencies/impl_/find_dependency)

#[[[
# Ensures that the project either finds or will build a necessary dependency.
#
# This is the user-facing API for package management. Users specify the
# package that their build system depends on, and how to build it. Then when
# the build system runs CMaize attempts to find an already installed version of
# the dependency. If it can not, then CMaize will use the provided information
# to build it.
#
# :param _fobdc_name: Name of the dependency.
# :type _fobdc_name: desc
# :param **kwargs: Additional keyword arguments may be necessary.
#      See _fob_parse_arguemnts for up to date list.
#]]
function(cmaize_find_or_build_dependency _fobd_name)

    cpp_get_global(_fobd_project CMAIZE_TOP_PROJECT)
    _cmaize_find_dependency(
        _fobd_tgt
        _fobd_pm
        _fobd_package_specs
        "${_fobd_project}"
        "${_fobd_name}"
        ${ARGN}
    )

    # If _fobd_tgt is non-empty we found it!!!
    if(NOT "${_fobd_tgt}" STREQUAL "")
        cpp_return("")
    endif()

    message(STATUS "Attempting to fetch and build ${_fobd_name}")

    PackageManager(GET "${_fobd_pm}" _fobd_pm_name type)

    if("${_fobd_pm_name}" STREQUAL "cmake")
        PackageManager(get_package
            "${_fobd_pm}" _fobd_tgt "${_fobd_package_specs}" ${ARGN}
        )

        # This creates the suspected install prefix for this dependency
        cpp_get_global(_fobd_top_proj CMAIZE_TOP_PROJECT)
        CMaizeProject(GET "${_fobd_top_proj}" _fobd_top_proj_name name)
        file(REAL_PATH
            "${CMAKE_INSTALL_LIBDIR}/${_fobd_top_proj_name}/external"
            _fobd_external_prefix
            BASE_DIRECTORY "${CMAKE_INSTALL_PREFIX}"
        )

        # Get the build target name for the dependency, since it is not
        # necessarily the same as the name of the CMaize target
        CMaizeTarget(target "${_fobd_tgt}" _fobd_build_tgt)

        # Create some possible paths where the dependency library will be
        # installed
        set(
            _fobd_install_paths
            "${_fobd_external_prefix}/lib"
            "${_fobd_external_prefix}/lib/${_fobd_name}"
            "${_fobd_external_prefix}/lib/${_fobd_build_tgt}"
        )
        list(REMOVE_DUPLICATES _fobd_install_paths)
        CMaizeTarget(SET "${_fobd_tgt}" install_path "${_fobd_install_paths}")
    # TODO: PIPPackageManager should be refactored to be consistent with
    #       CMakePackageManager's workflow.
    else()
        PackageManager(install_package "${_fobd_pm}" "${_fobd_package_specs}")
        PackageManager(
            get_package "${_fobd_pm}" _fobd_tgt "${_fobd_package_specs}"
        )
    endif()

    # The command above will throw build errors from inside FetchContent
    # if the fetch and build fails, so we can assume at this point that
    # it completed successfully
    CMaizeProject(add_target
        "${_fobd_project}" "${_fobd_name}" "${_fobd_tgt}"
    )

    message(STATUS "${_fobd_name} build complete")

endfunction()
