include_guard()

## Given a set of paths determines "``CMAKE_PREFIX_PATH``" for the set
#
# When we find a dependency we get back a target with the paths baked in. If we
# want to find the same target again the easiest way is to know the install root
# common to those paths. This function determines that root path.
#
# :param path: An identifier to hold the returned root path
# :param list: The list of paths we want the common root of.
function(_cpp_filesystem_common_path _cfcp_path _cfcp_list)

endfunction()
