include_guard()
include(cmakepp_lang/cmakepp_lang)

#[[[
# User function to install a package.
#
# :param _cap_tgt_name: Name of the target to be installed.
# :type _cap_tgt_name: desc
#]]
function(cmaize_add_package _cap_tgt_name)

    set(_cal_options INCLUDE_DIR)
    set(_cal_lists INCLUDE_DIRS)
    cmake_parse_arguments(_cal "" "${_cal_options}" "${_cal_lists}" ${ARGN})

    cpp_get_global(_cap_proj CMAIZE_PROJECT_${PROJECT_NAME})

    CMaizeProject(GET "${_cap_proj}" _cap_pms package_managers)
    CMaizeProject(GET "${_cap_proj}" tgt_list targets)

    # TODO: Expand this to different package managers
    # TODO: Only use CMake package manager right now, but people could
    #       expand to others later
    list(GET _cap_pms 0 pm)

    foreach(tgt_i ${tgt_list})
        Target(target "${tgt_i}" _cap_name)
        if("${_cap_name}" STREQUAL "${_cap_tgt_name}")
            PackageManager(install_package "${pm}" "${tgt_i}" ${_cal_UNPARSED_ARGUMENTS})
            cpp_return("")
        endif()
    endforeach()

endfunction()
