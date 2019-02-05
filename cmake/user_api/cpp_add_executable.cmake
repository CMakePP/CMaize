include_guard()

function(cpp_add_executable _cae_name)
    set(_cae_O_KWARGS CXX_STANDARD INCLUDE_DIR)
    set(_cae_M_KWARGS SOURCES DEPENDS)
    cmake_parse_arguments(
            _cae "" "${_cae_O_KWARGS}" "${_cae_M_KWARGS}" ${ARGN}
    )
    _cpp_is_not_empty(_cae_has_src _cae_SOURCES)
    _cpp_assert_true(_cae_has_src)
    add_executable(${_cae_name} ${_cae_SOURCES})
    cpp_option(_cae_CXX_STANDARD 17)
    cpp_option(_cae_INCLUDE_DIR ${PROJECT_SOURCE_DIR})
    target_include_directories(
            ${_cae_name}
            PRIVATE $<BUILD_INTERFACE:${_cae_INCLUDE_DIR}>
            $<INSTALL_INTERFACE:include>
    )
    target_compile_features(
            ${_cae_name} PUBLIC "cxx_std_${_cae_CXX_STANDARD}"
    )
    _cpp_is_not_empty(_cae_has_deps _cae_DEPENDS)
    if(_cae_has_deps)
        target_link_libraries(${_cae_name} ${_cae_DEPENDS})
    endif()
endfunction()
