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

set(_cpm_impl_dir "cmaize/package_managers/cmake/cmake_package_manager_impl_")

include(${_cpm_impl_dir}/ctor)
include(${_cpm_impl_dir}/generate_package_config)
include(${_cpm_impl_dir}/generate_target_config)
include(${_cpm_impl_dir}/install_package)
