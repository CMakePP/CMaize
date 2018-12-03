include_guard()
include(dependency/cpp_sanitize_version)

macro(_cpp_find_from_config _cffc_name _cffc_version _cffc_comps _cffc_path)
    #This only honors CMAKE_PREFIX_PATH and whatever paths were provided
    _cpp_sanitize_version(_cffc_temp "${_cffc_version}")
    _cpp_debug_print(
        "Attempting to find ${_cffc_name} version ${_cffc_temp} via config."
    )
    _cpp_debug_print("CMAKE_PREFIX_PATH is: ${CMAKE_PREFIX_PATH}")
    _cpp_debug_print("Additional search path: ${_cffc_path}")
    find_package(
        ${_cffc_name}
        ${_cffc_temp}
        ${_cffc_comps}
        CONFIG
        QUIET
        PATHS "${_cffc_path}"
        NO_PACKAGE_ROOT_PATH
        NO_SYSTEM_ENVIRONMENT_PATH
        NO_CMAKE_PACKAGE_REGISTRY
        NO_CMAKE_SYSTEM_PATH
        NO_CMAKE_SYSTEM_PACKAGE_REGISTRY
    )
endmacro()
