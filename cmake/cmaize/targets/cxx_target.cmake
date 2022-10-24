include_guard()
include(CheckLanguage)
include(cmakepp_lang/cmakepp_lang)
include(cmaize/targets/build_target)

#[[[
# Wraps a target which must be built as part of the build system.
#]]
cpp_class(CXXTarget BuildTarget)

    #[[[
    # :type: int
    #
    # CXX standard to use. For a given C++ standard designation, denoted as
    # ``cxx_std_xx`` or "C++ xx", only provide the number, "xx" of the 
    # standard.
    #
    # Following the precident set forth by CMake for the ``CXX_STANDARD``
    # target property, this property is initialized to ``CMAKE_CXX_STANDARD``
    # if it is set when the target is created.
    #]]
    cpp_attr(CXXTarget cxx_standard "${CMAKE_CXX_STANDARD}")

    #[[[
    # :type: path
    #
    # Directory containing source code files.
    #]]
    cpp_attr(CXXTarget source_dir)

    #[[[
    # :type: List[path]
    #
    # Source files.
    #]]
    cpp_attr(CXXTarget sources)

    #[[[
    # Create the target and configure its properties so it is ready to build.
    #
    # .. note::
    # 
    #    Implements ``BuildTarget(make_target``.
    #
    # :param self: CXXTarget object
    # :type self: CXXTarget
    # :param SOURCE_DIR: Directory containing source code.
    # :type SOURCE_DIR: path, optional
    # :param INCLUDE_DIRS: Directories containing files to include.
    # :type INCLUDE_DIRS: List[path], optional
    # :param SOURCES: Source code files.
    # :type SOURCES: List[path], optional
    # :param INCLUDES: Include files.
    # :type INCLUDES: List[path], optional
    # :param CXX_STANDARD: CXX standard number. For example, to set the
    #                      standard to ``cxx_std_98``, only provide ``98``.
    # :type CXX_STANDARD: int, optional
    # :param DEPENDS: Dependency target names.
    # :type DEPENDS: List[desc], optional
    #]]
    cpp_member(make_target CXXTarget args)
    function("${make_target}" self)

        set(_mt_options CXX_STANDARD SOURCE_DIR)
        set(_mt_lists DEPENDS INCLUDES SOURCES INCLUDE_DIRS)
        cmake_parse_arguments(_mt "" "${_mt_options}" "${_mt_lists}" ${ARGN})

        list(APPEND _mt_full_options ${_mt_options} ${_mt_lists})
        foreach(_mt_option_i ${_mt_full_options})
            if(NOT "${_mt_${_mt_option_i}}" STREQUAL "")
                string(TOLOWER "${_mt_option_i}" _mt_lc_option)
                CXXTarget(
                    SET "${self}"
                    "${_mt_lc_option}" "${_mt_${_mt_option_i}}"
                )
            endif()
        endforeach()

        # Default the CXX standard to CMAKE_CXX_STANDARD. This cannot be
        # done by defaulting the attribute during the ``cpp_attr`` call
        # since CMaize will be included before a project has been defined,
        # making CMAKE_CXX_STANDARD, at the time of including, an empty
        # string.
        CXXTarget(GET "${self}" _mt_cxx_std cxx_standard)
        if("${_mt_cxx_std}" STREQUAL "")
            CXXTarget(SET "${self}" cxx_standard "${CMAKE_CXX_STANDARD}")
        endif()

        # Make all of the calls to create the CMake target and set its
        # properties
        CXXTarget(_create_target "${self}")
        CXXTarget(_set_compile_features "${self}")
        CXXTarget(_set_include_directories "${self}")
        CXXTarget(_set_link_libraries "${self}")
        CXXTarget(_set_public_headers "${self}")
        CXXTarget(_set_sources "${self}")

    endfunction()

    #[[[
    # Abstracts out CMake's access level concept (public, interface, or 
    # private).
    # 
    # :param self: CXXTarget object
    # :type self: CXXTarget
    # :param _al_access_level: Returned access level.
    # :type _al_access_level: str*
    #
    # :returns: CMake access level of the target.
    # :rtype: str
    #]]
    cpp_member(_access_level CXXTarget desc)
    function("${_access_level}" self _al_access_level)

        set("${_al_access_level}" PUBLIC)
        cpp_return("${_al_access_level}")

    endfunction()

    #[[[
    # Sets the CXX standard and other compiler features on the CMake target.
    # 
    # :param self: CXXTarget object
    # :type self: CXXTarget
    #]]
    cpp_member(_set_compile_features CXXTarget)
    function("${_set_compile_features}" self)

        CXXTarget(target "${self}" _scf_tgt_name)
        CXXTarget(GET "${self}" _scf_cxx_std cxx_standard)

        # The CXX std will always have PUBLIC access
        target_compile_features(
            "${_scf_tgt_name}"
            PUBLIC
                "cxx_std_${_scf_cxx_std}"
        )

    endfunction()

    #[[[
    # Set the target include directories. This adds the include directories
    # as PUBLIC and source directories as PRIVATE. This allows for both
    # public and private headers to be found.
    #
    # .. note::
    # 
    #    Implements ``BuildTarget(_set_include_directories``.
    #
    # :param self: CXXTarget object
    # :type self: CXXTarget
    #]]
    cpp_member(_set_include_directories CXXTarget)
    function("${_set_include_directories}" self)

        CXXTarget(target "${self}" _sid_tgt_name)
        CXXTarget(GET "${self}" _sid_inc_dirs include_dirs)
        CXXTarget(GET "${self}" _sid_src_dir source_dir)

        foreach(_sid_inc_dir_i ${_sid_inc_dirs})
            get_filename_component(
                _sid_trunc_inc_dir
                "${_sid_inc_dir_i}"
                DIRECTORY)
            list(APPEND _sid_inc_dirs "${_sid_trunc_inc_dir}")
        endforeach()

        # Set up public includes
        foreach(_sid_inc_dir_i ${_sid_inc_dirs})
            target_include_directories(
                "${_sid_tgt_name}"
                PUBLIC
                    $<BUILD_INTERFACE:${_sid_inc_dir_i}>
            )
        endforeach()

        # Set up installation includes
        target_include_directories(
            "${_sid_tgt_name}"
            PUBLIC
                $<INSTALL_INTERFACE:include>
        )

        # Set up private header includes
        target_include_directories(
            "${_sid_tgt_name}"
            PRIVATE
                "${_sid_src_dir}"
        )

    endfunction()

    #[[[
    # Set the link libraries for the target. Uses the ``depends`` list
    # to determine what targets to link.
    # 
    # :param self: CXXTarget object
    # :type self: CXXTarget
    #]]
    cpp_member(_set_link_libraries CXXTarget)
    function("${_set_link_libraries}" self)

        CXXTarget(target "${self}" _sll_name)
        CXXTarget(GET "${self}" _sll_deps depends)

        foreach(_sll_dep_i ${_sll_deps})
            target_link_libraries("${_sll_name}" PUBLIC "${_sll_dep_i}")
        endforeach()

    endfunction()

    #[[[
    # Set the public headers on the target. It is set to all include files
    # on this object.
    # 
    # :param self: CXXTarget object
    # :type self: CXXTarget
    #]]
    cpp_member(_set_public_headers CXXTarget)
    function("${_set_public_headers}" self)

        CXXTarget(GET "${self}" _sph_inc_files includes)

        # TODO: This may hang if '_sph_inc_files' is empty
        CXXTarget(set_property "${self}" PUBLIC_HEADER "${_sph_inc_files}")

    endfunction()

    #[[[
    # Set the sources for the target. Sources are set with the PRIVATE
    # accessor so they are not propogated.
    #
    # :param self: CXXTarget object
    # :type self: CXXTarget
    #]]
    cpp_member(_set_sources CXXTarget)
    function("${_set_sources}" self)

        CXXTarget(target "${self}" _ss_tgt_name)
        CXXTarget(GET "${self}" _ss_src_files sources)

        # Sources for a CXX target should be private
        target_sources(
            "${_ss_tgt_name}"
            PRIVATE
                ${_ss_src_files}
        )

    endfunction()

cpp_end_class()
