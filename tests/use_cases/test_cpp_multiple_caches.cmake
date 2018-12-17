include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
include(cpp_toolchain)
_cpp_setup_test_env("multiple_caches")

# In this scenario a user has built a project using one CPP cache and now
# they are building a different project, using a different CPP cache.

#Step 1: Write the source files for our package
set(src_dir ${test_prefix}/dummy1)
_cpp_dummy_cxx_package(${test_prefix} NAME dummy1)

#Step 2: Build package and record it's cache
set(project1_cache ${CPP_INSTALL_CACHE})
_cpp_add_test(
TITLE "Build project one"
"include(dependency/cpp_find_or_build_dependency)"
"cpp_find_or_build_dependency("
"    NAME dummy1"
"    SOURCE_DIR ${src_dir}"
")"
"_cpp_assert_exists(${project1_cache}/dummy1)"
)

#Step 3: Attempt to find dependency w/wrong cache
_cpp_add_test(
TITLE "Fails to find project one"
SHOULD_FAIL REASON "Could not find dummy1"
"include(dependency/cpp_find_dependency)"
"set(CPP_INSTALL_CACHE ${test_prefix}/cpp_cache2)"
"cpp_find_dependency("
"   NAME dummy1"
")"
)

#Step 4: Ghetto work around works
_cpp_add_test(
TITLE "Can manually specify cache in the call"
"include(dependency/cpp_find_dependency)"
"cpp_find_dependency("
"   NAME dummy1"
"   CPP_CACHE ${project1_cache}"
")"
)
