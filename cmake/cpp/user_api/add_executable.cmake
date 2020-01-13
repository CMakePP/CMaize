include_guard()
include(cpp/targets/cxx_executable)

function(cpp_add_executable _ae_name)
    cmake_parse_arguments(_ae "" "SOURCE_DIR" "" ${ARGN})

    # TODO: Actually establish that we are making a C++ executable

    file(GLOB_RECURSE _ae_src
         LIST_DIRECTORIES FALSE
         CONFIGURE_DEPENDS
         "${_ae_SOURCE_DIR}/*.cpp"
    )

    CXXExecutable(CTOR _ae_exe)
    CXXExecutable(
        MAKE_TARGET "${_ae_exe}"
        NAME "${_ae_name}"
        SOURCES ${_ae_src}
        ${ARGN}
    )
endfunction()
