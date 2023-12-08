include_guard()

set(_cpm_impl_dir "cmaize/package_managers/cmake/cmake_package_manager_impl_")

include(${_cpm_impl_dir}/ctor)
include(${_cpm_impl_dir}/generate_package_config)
include(${_cpm_impl_dir}/generate_target_config)
include(${_cpm_impl_dir}/install_package)
