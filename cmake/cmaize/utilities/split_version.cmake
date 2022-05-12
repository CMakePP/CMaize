include_guard()

#[[[
# Split the given version string into its components. Some return values
# may be blank.
#
# :param major: Returned first component of the version.
# :type major: str
# :param minor: Returned second component of the version.
# :type minor: str
# :param patch: Returned third component of the version.
# :type patch: str
# :param tweak: Returned fourth component of the version.
# :type tweak: str
# :param version: Version string to be separated into components.
# :type version: str
#
# :returns: ``major`` will be set to the first component of ``version``.
# :rtype: str
# :returns: ``minor`` will be set to the second component of ``version``.
# :rtype: str
# :returns: ``patch`` will be set to the third component of ``version``.
# :rtype: str
# :returns: ``tweak`` will be set to the fourth component of ``version``.
# :rtype: str
#]]
function(cmaize_split_version major minor patch tweak version)

    # Split the version into components
    string(REPLACE "." ";" version_comps "${version}")

    list(LENGTH version_comps comp_count)

    if (comp_count GREATER_EQUAL 1)
        list(GET version_comps 0 tmp_major)
        set(major "${tmp_major}" PARENT_SCOPE)
    endif()
    if (comp_count GREATER_EQUAL 2)
        list(GET version_comps 1 tmp_minor)
        set(minor "${tmp_minor}" PARENT_SCOPE)
    endif()
    if (comp_count GREATER_EQUAL 3)
        list(GET version_comps 2 tmp_patch)
        set(patch "${tmp_patch}" PARENT_SCOPE)
    endif()
    if (comp_count GREATER_EQUAL 4)
        list(GET version_comps 3 tmp_tweak)
        set(tweak "${tmp_tweak}" PARENT_SCOPE)
    endif()

endfunction()
