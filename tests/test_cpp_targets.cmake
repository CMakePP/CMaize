include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_cmake_helpers)
include(cpp_unit_test_helpers.cmake)
include(cpp_targets)
include(cpp_print)

_cpp_setup_build_env("cpp_targets")
set(CPP_DEBUG_MODE ON)

################################################################################
# Test _cpp_parse_target
################################################################################

_cpp_parse_target(test1_proj test1_comp "cpp::component")
_cpp_assert_equal("${test1_proj}" "cpp")
_cpp_assert_equal("${test1_comp}" "component")

_cpp_parse_target(test2_proj test2_comp "cpp")
_cpp_assert_equal("${test2_proj}" "cpp")
_cpp_assert_equal("${test2_comp}" "")


################################################################################
# Test cpp_add_library
################################################################################

#Set-up a little dummy library
set(test_root ${test_prefix}/add_library)
set(test1_root ${test_root}/test1)
_cpp_dummy_cxx_library(${test1_root})

set(include_corr "INCLUDE_DIRECTORIES : $<BUILD_INTERFACE:${test1_root}>")
list(APPEND include_corr "$<INSTALL_INTERFACE:include>")
_cpp_run_sub_build(
    ${test1_root}
    NO_INSTALL
    OUTPUT test1_output
    NAME test1
    CONTENTS "include(cpp_targets)
              include(cpp_print)
              cpp_add_library(
                  dummy
                  SOURCES ${test1_root}/a.cpp
                  INCLUDES ${test1_root}/a.hpp
              )
              _cpp_print_target(dummy)"
)
_cpp_assert_contains("Target : dummy" "${test1_output}")
_cpp_assert_contains("SOURCES : ${test1_root}/a.cpp" "${test1_output}")
_cpp_assert_contains("COMPILE_FEATURES : cxx_std_17" "${test1_output}")
_cpp_assert_contains("PUBLIC_HEADER : ${test1_root}/a.hpp" "${test1_output}")
_cpp_assert_contains("${include_corr}" "${test1_output}")

#Header-only
set(test2_root ${test_root}/test2)
_cpp_dummy_cxx_library(${test2_root})

set(include_corr "INCLUDE_DIRECTORIES : $<BUILD_INTERFACE:${test2_root}>")
list(APPEND include_corr "$<INSTALL_INTERFACE:include>")
_cpp_run_sub_build(
    ${test2_root}
    NO_INSTALL
    OUTPUT test2_output
    NAME dummy
    CONTENTS "include(cpp_targets)
              include(cpp_print)
              cpp_add_library(
                  dummy
                  INCLUDES ${test2_root}/a.hpp
              )
              _cpp_print_interface(dummy)"
)
_cpp_assert_contains("Target : dummy" "${test2_output}")
_cpp_assert_contains("COMPILE_FEATURES : cxx_std_17" "${test2_output}")
_cpp_assert_contains("${include_corr}" "${test2_output}")

#Target with a dependency
set(test3_root ${test_root}/test3)
_cpp_dummy_cxx_library(${test3_root})
_cpp_run_sub_build(
    ${test3_root}
    NO_BUILD NO_INSTALL
    OUTPUT test3_output
    NAME dummy
    CONTENTS "include(cpp_targets)
              include(cpp_print)
              add_library(depend1 INTERFACE)
              target_include_directories(depend1 INTERFACE /a/path)
              cpp_add_library(
                  dummy
                  SOURCES ${test3_root}/a.cpp
                  INCLUDES ${test3_root}/a.hpp
                  DEPENDS depend1
              )
              _cpp_print_target(dummy)"
)
_cpp_assert_contains("LINK_LIBRARIES : depend1" "${test3_output}")

#Target that requires different C++ support
set(test4_root ${test_root}/test4)
_cpp_dummy_cxx_library(${test4_root})
_cpp_run_sub_build(
    ${test4_root}
    NO_BUILD NO_INSTALL
    OUTPUT test4_output
    NAME dummy
    CONTENTS "include(cpp_targets)
              include(cpp_print)
              cpp_add_library(
                  dummy
                  SOURCES ${test4_root}/a.cpp
                  INCLUDES ${test4_root}/a.hpp
                  CXX_STANDARD 14
              )
              _cpp_print_target(dummy)"
)
_cpp_assert_contains("COMPILE_FEATURES : cxx_std_14" "${test4_output}")

#Static library w/o sources is an error
set(test5_root ${test_root}/test5)
_cpp_dummy_cxx_library(${test5_root})
_cpp_test_build_fails(
    PATH ${test5_root}
    NAME dummy
    CONTENTS "include(cpp_targets)
              cpp_add_library(
                  dummy
                  STATIC
                  INCLUDES ${test5_root}/a.hpp
              )"
    REASON "Static libraries need source files..."
)

#Can change the include dir
set(test6_root ${test_root}/test6)
_cpp_dummy_cxx_library(${test6_root})
set(include_corr "INCLUDE_DIRECTORIES : $<BUILD_INTERFACE:/a/path>")
list(APPEND include_corr "$<INSTALL_INTERFACE:include>")
_cpp_run_sub_build(
    ${test6_root}
    NO_INSTALL
    OUTPUT test6_output
    NAME dummy
    CONTENTS "include(cpp_targets)
              include(cpp_print)
              cpp_add_library(
                  dummy
                  INCLUDE_DIR /a/path
                  INCLUDES ${test6_root}/a.hpp
              )
              _cpp_print_interface(dummy)"
)
_cpp_assert_contains("${include_corr}" "${test6_output}")

################################################################################
# Test cpp_add_executable
################################################################################

set(test_root ${test_prefix}/add_executable)
set(test1_root ${test_root}/test1)
_cpp_dummy_cxx_executable(${test1_root})
_cpp_run_sub_build(
    ${test1_root}
    NAME test1
    NO_INSTALL
    OUTPUT test1_output
    CMAKE_ARGS CPP_DEBUG_MODE=ON
    CONTENTS "include(cpp_targets)
              cpp_add_executable(
                  dummy
                  SOURCES ${test1_root}/main.cpp
              )"
)
_cpp_assert_contains("[100%] Built target dummy" "${test1_output}")

set(test2_root ${test_root}/test2)
_cpp_dummy_cxx_library(${test2_root})
file(WRITE ${test2_root}/main.cpp "#include a.hpp\nint main(){return a_Fxn;}")
_cpp_run_sub_build(
    ${test2_root}
    NAME test2
    NO_INSTALL
    OUTPUT test2_output
    CMAKE_ARGS CPP_DEBUG_MODE=ON
    CONTENTS "include(cpp_targets)
             cpp_add_library(
                 dummy
                 INCLUDES ${test2_root}/a.hpp
                 SOURCES ${test2_root}/a.cpp
             )
             cpp_add_executable(
                test2
                SOURCES ${test2_root}/main.cpp
                DEPENDS dummy
             )"
)
_cpp_assert_contains("[100%] Built target dummy" "${test1_output}")

################################################################################
# Test cpp_install
################################################################################

set(test_root ${test_prefix}/cpp_install)

#Uber basic library
set(test1_root ${test_root}/test1)
_cpp_dummy_cxx_library(${test1_root})

set(test1_install ${test1_root}/install)
_cpp_run_sub_build(
    ${test1_root}
    OUTPUT test1_output
    INSTALL_PREFIX ${test1_install}
    NAME dummy
    CONTENTS "include(cpp_targets)
              cpp_add_library(
                  dummy
                  INCLUDES a.hpp
                  SOURCES a.cpp
              )
              cpp_install(TARGETS dummy)"
)
set(test1_share ${test1_install}/share/cmake/dummy)

#Existence checks
_cpp_assert_exists(${test1_install})
_cpp_assert_exists(${test1_install}/lib/dummy)
_cpp_assert_exists(${test1_install}/include/dummy/a.hpp)
_cpp_assert_exists(${test1_share}/dummy-config.cmake)
_cpp_assert_exists(${test1_share}/dummy-config-version.cmake)
_cpp_assert_exists(${test1_share}/dummy-targets.cmake)
_cpp_assert_exists(${test1_share}/dummy-targets-debug.cmake)

#Content checks
file(READ ${test1_share}/dummy-targets.cmake test1_targets)
_cpp_assert_contains("dummy::dummy" "${test1_targets}")

#Library with dependency
set(test2_root ${test_root}/test2)
_cpp_dummy_cxx_library(${test2_root})

set(test2_install ${test2_root}/install)
_cpp_run_sub_build(
        ${test2_root}
        OUTPUT test2_output
        INSTALL_PREFIX ${test2_install}
        NAME dummy
        CONTENTS "include(cpp_targets)
                  add_library(depend1 IMPORTED INTERFACE)
                  cpp_add_library(
                      dummy
                      INCLUDES ${test2_root}/a.hpp
                      SOURCES ${test2_root}/a.cpp
                      DEPENDS depend1
                  )
                  cpp_install(TARGETS dummy)"
)

set(test2_share ${test2_install}/share/cmake/dummy)
file(READ ${test2_share}/dummy-config.cmake test2_config)
_cpp_assert_contains("depend1" "${test2_config}")


#Errs if library has non-target dependency
set(test3_root ${test_root}/test3)
_cpp_dummy_cxx_library(${test3_root})
_cpp_test_build_fails(
    PATH ${test3_root}
    NAME dummy
    CONTENTS "include(cpp_targets)
              cpp_add_library(
                  dummy
                  INCLUDES ${test2_root}/a.hpp
                  SOURCES ${test2_root}/a.cpp
              )
              target_link_libraries(dummy INTERFACE liblibrary.a)
              cpp_install(TARGETS dummy)"
    REASON "liblibrary.a is not a target"
)

# Two components
set(test4_root ${test_root}/test4)
_cpp_dummy_cxx_library(${test4_root}/lib1)
_cpp_dummy_cxx_library(${test4_root}/lib2)
set(test4_install ${test4_root}/install)
_cpp_run_sub_build(
    ${test4_root}
    INSTALL_PREFIX ${test4_install}
    OUTPUT test4_output
    RESULT test4_result
    NAME dummy
    CONTENTS "include(cpp_targets)
              cpp_add_library(
                  dummy1
                  INCLUDES ${test4_root}/lib1/a.hpp
                  SOURCES ${test4_root}/lib1/a.cpp
              )
              cpp_add_library(
                  dummy2
                  INCLUDES ${test4_root}/lib2/a.hpp
                  SOURCES  ${test4_root}/lib2/a.cpp
              )
              cpp_install(TARGETS dummy1 dummy2)"
)
file(READ ${test4_install}/share/cmake/dummy/dummy-targets.cmake test4_targets)
_cpp_assert_contains("dummy::dummy1 dummy::dummy2" "${test4_targets}")

# Headerfile directory structure
set(test5_root ${test_root}/test5)
_cpp_dummy_cxx_library(${test5_root})
_cpp_dummy_cxx_library(${test5_root}/nested)
_cpp_dummy_cxx_library(${test5_root}/nested/nested)
set(test5_install ${test5_root}/install)
set(CPP_DEBUG_MODE ON)
_cpp_run_sub_build(
        ${test5_root}
        INSTALL_PREFIX ${test5_install}
        OUTPUT test5_output
        RESULT test5_result
        NAME dummy
        CONTENTS "include(cpp_targets)
              cpp_add_library(
                  dummy
                  INCLUDES nested/a.hpp
                           nested/nested/a.hpp
                  SOURCES  a.cpp
              )
              cpp_install(TARGETS dummy)"
)
_cpp_assert_does_not_exist(${test5_install}/include/dummy/a.hpp)
_cpp_assert_exists(${test5_install}/include/dummy/nested/a.hpp)
_cpp_assert_exists(${test5_install}/include/dummy/nested/nested/a.hpp)
