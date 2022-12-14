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
function(cmaize_split_version _sv_major _sv_minor _sv_patch _sv_tweak _sv_version)

    # Split the version into components
    string(REPLACE "." ";" _sv_version_comps "${_sv_version}")

    list(LENGTH _sv_version_comps _sv_comp_count)

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
