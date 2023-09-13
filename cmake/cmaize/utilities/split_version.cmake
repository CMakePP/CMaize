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

#[[[
# Split a given version string into its components.
#
# This function assumes that semantic versioning (`https://semver.org`__)
# is being used, as well as an additional, optional TWEAK component that
# CMake natively supports. Some return values may be blank if there are not
# four components to the version string.
#
# :param _sv_major: Returned first component of the version.
# :type _sv_major: desc
# :param _sv_minor: Returned second component of the version.
# :type _sv_minor: desc
# :param _sv_patch: Returned third component of the version.
# :type _sv_patch: desc
# :param _sv_tweak: Returned fourth component of the version.
# :type _sv_tweak: desc
# :param _sv_version: Version string to be separated into components.
# :type _sv_version: desc
#
# :returns: The first component of the given version.
# :rtype: desc
# :returns: The second component of the given version.
# :rtype: desc
# :returns: The third component of the given version.
# :rtype: desc
# :returns: The fourth component of the given version.
# :rtype: desc
#]]
function(cmaize_split_version
    _sv_major _sv_minor _sv_patch _sv_tweak _sv_version
)

    # Split the version into components
    string(REPLACE "." ";" _sv_version_comps "${_sv_version}")

    list(LENGTH _sv_version_comps _sv_comp_count)

    # Extract each existing component
    if (_sv_comp_count GREATER_EQUAL 1)
        list(GET _sv_version_comps 0 _sv_tmp_major)
        set("${_sv_major}" "${_sv_tmp_major}" PARENT_SCOPE)
    endif()
    if (_sv_comp_count GREATER_EQUAL 2)
        list(GET _sv_version_comps 1 _sv_tmp_minor)
        set("${_sv_minor}" "${_sv_tmp_minor}" PARENT_SCOPE)
    endif()
    if (_sv_comp_count GREATER_EQUAL 3)
        list(GET _sv_version_comps 2 _sv_tmp_patch)
        set("${_sv_patch}" "${_sv_tmp_patch}" PARENT_SCOPE)
    endif()
    if (_sv_comp_count GREATER_EQUAL 4)
        list(GET _sv_version_comps 3 _sv_tmp_tweak)
        set("${_sv_tweak}" "${_sv_tmp_tweak}" PARENT_SCOPE)
    endif()

endfunction()
