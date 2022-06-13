include_guard()
include(CheckLanguage)
include(cmakepp_lang/cmakepp_lang)
include(cmaize/targets/build_target)

#[[[
# Wraps a target which must be built as part of the build system.
#]]
cpp_class(CXXTarget BuildTarget)

    #[[[
    # :type: str
    #
    # CXX standard to use. For a given C++ standard designation, denoted as
    # ``cxx_std_xx`` or "C++ xx", only provide the number, "xx" of the 
    # standard. Defaults to 17.
    #]]
    cpp_attr(CXXTarget cxx_standard 17)

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
    # Construct a ``CXXTarget`` object. This ctor enables the CXX language
    # if it has not already been enabled.
    #
    # .. warning::
    #    
    #    If an existing CMake target name is provided, the CXX language must
    #    already be enabled upon creation of the CMake target, otherwise it
    #    will not have the correct properties.
    # 
    # :param self: CXXTarget object
    # :type self: CXXTarget
    #]]
    cpp_constructor(CTOR CXXTarget str)
    function("${CTOR}" self tgt_name)

        # Call the parent ctor
        BuildTarget(CTOR "${self}" "${tgt_name}")

        # Make sure the CXX language has been enabled
        check_language(CXX)
        if(CMAKE_CXX_COMPILER)
            enable_language(CXX)
        else()
            message(STATUS "No CXX support")
        endif()

    endfunction()

    #[[[
    # Create the target and configure its properties so it is ready to build.
    #
    # :param self: CXXTarget object
    # :type self: CXXTarget
    #]]
    cpp_member(make_target CXXTarget args)
    function("${make_target}" self)

        set(_mt_options CXX_STANDARD SOURCE_DIR)
        set(_mt_lists DEPENDS INCLUDES SOURCES INCLUDE_DIRS)
        cmake_parse_arguments(_mt "" "${_mt_options}" "${_mt_lists}" ${ARGN})

        foreach(_mt_option_i CXX_STANDARD DEPENDS INCLUDES SOURCES INCLUDE_DIRS SOURCE_DIR)
            if(NOT "${_mt_${_mt_option_i}}" STREQUAL "")
                string(TOLOWER "${_mt_option_i}" _mt_lc_option)
                CXXTarget(
                    SET "${self}"
                    "${_mt_lc_option}" "${_mt_${_mt_option_i}}"
                )
            endif()
        endforeach()

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
    # :param result: Returned access level.
    # :param result: str*
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

        CXXTarget(target "${self}" tgt_name)
        CXXTarget(GET "${self}" cxx_std cxx_standard)

        # The CXX std will always have PUBLIC access
        target_compile_features("${tgt_name}" PUBLIC "cxx_std_${cxx_std}")

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
            get_filename_component(_sid_trunc_inc_dir "${_sid_inc_dir_i}" DIRECTORY)
            list(APPEND _sid_inc_dirs "${_sid_trunc_inc_dir}")
        endforeach()

        # Include all header files for the project, both from the public API
        # and private headers
        foreach(_sid_inc_dir_i ${_sid_inc_dirs})
            target_include_directories(
                "${_sid_tgt_name}"
                PUBLIC
                    $<BUILD_INTERFACE:${_sid_inc_dir_i}>
            )
        endforeach()

        target_include_directories(
            "${_sid_tgt_name}"
            PUBLIC
                $<INSTALL_INTERFACE:include>
            PRIVATE
                "${src_dir}"
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

        CXXTarget(target "${self}" tgt_name)
        CXXTarget(GET "${self}" inc_files includes)

        if(NOT "${inc_files}" STREQUAL "")
            CXXTarget(set_property "${self}" PUBLIC_HEADER "${inc_files}")
        endif()
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

        CXXTarget(target "${self}" tgt_name)
        CXXTarget(GET "${self}" src_files sources)

        # Sources for a CXX target should be private
        target_sources(
            "${tgt_name}"
            PRIVATE
                ${src_files}
        )

    endfunction()

cpp_end_class()
