include_guard()

# Included first so __CMAIZE_PACKAGE_MANAGER_MAP__ is initialized first
include(cmaize/package_managers/get_package_manager)

# TODO: Should these be private and not included here, now that we use
#       `get_package_manager_instance()`?
include(cmaize/package_managers/cmake/cmake)
include(cmaize/package_managers/package_manager)
