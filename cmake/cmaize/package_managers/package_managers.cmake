include_guard()

# Included first so __CMAIZE_PACKAGE_MANAGER_MAP__ is initialized first
include(cmaize/package_managers/get_package_manager)

include(cmaize/package_managers/cmake/cmake)
include(cmaize/package_managers/package_manager)
