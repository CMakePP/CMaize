include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_cmake_helpers)
include(cpp_unit_test_helpers.cmake)
include(cpp_targets)
include(cpp_print)

_cpp_setup_build_env("cpp_targets")

################################################################################
# Test cpp_add_library
################################################################################

#Set-up a little dummy library
set(test_root ${test_prefix}/add_library)
set(test1_root ${test_root}/test1)
_cpp_dummy_cxx_library(${test1_root})
_cpp_write_top_list(
    PATH ${test1_root}
    NAME test1
    CONTENTS
    "include(cpp_targets)
     include(cpp_print)
     cpp_add_library(
        dummy
        SOURCES ${test1_root}/a.cpp
        INCLUDES ${test1_root}/a.hpp
     )
     _cpp_print_target(dummy)"
)

set(include_corr "INCLUDE_DIRECTORIES : $<BUILD_INTERFACE:${test1_root}>")
list(APPEND include_corr "$<INSTALL_INTERFACE:include>")
_cpp_run_sub_build(${test1_root} NO_INSTALL OUTPUT test1_output)
_cpp_assert_contains("Target : dummy" "${test1_output}")
_cpp_assert_contains("SOURCES : ${test1_root}/a.cpp" "${test1_output}")
_cpp_assert_contains("COMPILE_FEATURES : cxx_std_17" "${test1_output}")
_cpp_assert_contains("PUBLIC_HEADER : ${test1_root}/a.hpp" "${test1_output}")
_cpp_assert_contains("${include_corr}" "${test1_output}")

#Header-only
set(test2_root ${test_root}/test2)
_cpp_dummy_cxx_library(${test2_root})
_cpp_write_top_list(
        PATH ${test2_root}
        NAME dummy
        CONTENTS
        "include(cpp_targets)
         include(cpp_print)
         cpp_add_library(
            dummy
            INCLUDES ${test2_root}/a.hpp
         )
         _cpp_print_interface(dummy)"
)
set(include_corr "INCLUDE_DIRECTORIES : $<BUILD_INTERFACE:${test2_root}>")
list(APPEND include_corr "$<INSTALL_INTERFACE:include>")
_cpp_run_sub_build(${test2_root} NO_INSTALL OUTPUT test2_output)
_cpp_assert_contains("Target : dummy" "${test2_output}")
_cpp_assert_contains("COMPILE_FEATURES : cxx_std_17" "${test2_output}")
_cpp_assert_contains("${include_corr}" "${test2_output}")

#Target with a dependency
set(test3_root ${test_root}/test3)
_cpp_dummy_cxx_library(${test3_root})
_cpp_write_top_list(
    PATH ${test3_root}
    NAME dummy
    CONTENTS
     "include(cpp_targets)
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
_cpp_run_sub_build(${test3_root} NO_BUILD NO_INSTALL OUTPUT test3_output)
_cpp_assert_contains("LINK_LIBRARIES : depend1" "${test3_output}")

#Target that requires different C++ support
set(test4_root ${test_root}/test4)
_cpp_dummy_cxx_library(${test4_root})
_cpp_write_top_list(
    PATH ${test4_root}
    NAME dummy
    CONTENTS
    "include(cpp_targets)
     include(cpp_print)
     cpp_add_library(
        dummy
        SOURCES ${test4_root}/a.cpp
        INCLUDES ${test4_root}/a.hpp
        CXX_STANDARD 14
     )
     _cpp_print_target(dummy)"
)
_cpp_run_sub_build(${test4_root} NO_BUILD NO_INSTALL OUTPUT test4_output)
_cpp_assert_contains("COMPILE_FEATURES : cxx_std_14" "${test4_output}")

#Static library w/o sources is an error
set(test5_root ${test_root}/test5)
_cpp_dummy_cxx_library(${test5_root})
_cpp_write_top_list(
    PATH ${test5_root}
    NAME dummy
    CONTENTS
    "include(cpp_targets)
     cpp_add_library(
        dummy
        STATIC
        INCLUDES ${test5_root}/a.hpp
     )"
)
_cpp_run_cmake_command(
    INCLUDES cpp_cmake_helpers
    CMAKE_ARGS CPP_DEBUG_MODE=ON
    COMMAND "_cpp_run_sub_build(${test5_root} NO_BUILD NO_INSTALL)"
    OUTPUT test5_output
    RESULT test5_result
)
_cpp_assert_true(test5_result)
_cpp_assert_contains("Static libraries need source files..." "${test5_output}")

#Can change the include dir
set(test6_root ${test_root}/test6)
_cpp_dummy_cxx_library(${test6_root})
_cpp_write_top_list(
        PATH ${test6_root}
        NAME dummy
        CONTENTS
        "include(cpp_targets)
         include(cpp_print)
         cpp_add_library(
            dummy
            INCLUDE_DIR /a/path
            INCLUDES ${test6_root}/a.hpp
         )
         _cpp_print_interface(dummy)"
)
set(include_corr "INCLUDE_DIRECTORIES : $<BUILD_INTERFACE:/a/path>")
list(APPEND include_corr "$<INSTALL_INTERFACE:include>")
_cpp_run_sub_build(${test6_root} NO_INSTALL OUTPUT test6_output)
_cpp_assert_contains("${include_corr}" "${test6_output}")

################################################################################
# Test cpp_install
################################################################################

set(test_root ${test_prefix}/cpp_install)

#Uber basic library
set(test1_root ${test_root}/test1)
_cpp_dummy_cxx_library(${test1_root})
_cpp_write_top_list(
        PATH ${test1_root}
        NAME dummy
        CONTENTS
        "include(cpp_targets)
         cpp_add_library(
            dummy
            INCLUDES ${test1_root}/a.hpp
            SOURCES ${test1_root}/a.cpp
         )
         cpp_install(TARGETS dummy)"
)

set(test1_install ${test1_root}/install)
_cpp_run_sub_build(
    ${test1_root}
    OUTPUT test1_output
    INSTALL_PREFIX ${test1_install}
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
_cpp_write_top_list(
        PATH ${test2_root}
        NAME dummy
        CONTENTS
        "include(cpp_targets)
         add_library(depend1 IMPORTED INTERFACE)
         cpp_add_library(
            dummy
            INCLUDES ${test2_root}/a.hpp
            SOURCES ${test2_root}/a.cpp
            DEPENDS depend1
         )
         cpp_install(TARGETS dummy)"
)

set(test2_install ${test2_root}/install)
_cpp_run_sub_build(
        ${test2_root}
        OUTPUT test2_output
        INSTALL_PREFIX ${test2_install}
)

set(test2_share ${test2_install}/share/cmake/dummy)
file(READ ${test2_share}/dummy-config.cmake test2_config)
_cpp_assert_contains("depend1" "${test2_config}")


#Errs if library has non-target dependency
set(test3_root ${test_root}/test3)
_cpp_dummy_cxx_library(${test3_root})
_cpp_write_top_list(
        PATH ${test3_root}
        NAME dummy
        CONTENTS
        "include(cpp_targets)
         cpp_add_library(
            dummy
            INCLUDES ${test2_root}/a.hpp
            SOURCES ${test2_root}/a.cpp
         )
         target_link_libraries(dummy INTERFACE liblibrary.a)
         cpp_install(TARGETS dummy)"
)
set(test3_install ${test3_root}/install)
_cpp_run_cmake_command(
        INCLUDES cpp_cmake_helpers
        CMAKE_ARGS CPP_DEBUG_MODE=ON
        COMMAND
        "_cpp_run_sub_build(${test3_root} INSTALL_PREFIX ${test3_install})"
        OUTPUT test3_output
        RESULT test3_result
)
_cpp_assert_true(test3_result)
_cpp_assert_contains("liblibrary.a is not a target" "${test3_output}")

# Two components
set(test4_root ${test_root}/test4)
_cpp_dummy_cxx_library(${test4_root}/lib1)
_cpp_dummy_cxx_library(${test4_root}/lib2)
_cpp_write_top_list(
        PATH ${test4_root}
        NAME dummy
        CONTENTS
        "include(cpp_targets)
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
set(test4_install ${test4_root}/install)
_cpp_run_sub_build(
        ${test4_root}
        INSTALL_PREFIX ${test4_install}
        OUTPUT test4_output
        RESULT test4_result
)
file(READ ${test4_install}/share/cmake/dummy/dummy-targets.cmake test4_targets)
_cpp_assert_contains("dummy::dummy1 dummy::dummy2" "${test4_targets}")
