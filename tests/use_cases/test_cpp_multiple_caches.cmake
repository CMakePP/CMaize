include(${CMAKE_TOOLCHAIN_FILE})
include(cpp_unit_test_helpers)
_cpp_setup_build_env("multiple_caches")

# In this scenario a user has built a project using one CPP cache and now
# they are building a different project, using a different CPP cache. Of note,
# we assume the second project uses the first project as a dependency.

#Step 1: Write the source files for our packages
set(src_dir ${test_prefix}/dummy1)
_cpp_dummy_cxx_package(${test_prefix} NAME dummy1)
_cpp_dummy_cxx_package(${test_prefix} NAME dummy2)

#Step 2: Build Project 1 and record it's cache
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

#Step 3: Change the cache
set(CPP_INSTALL_CACHE ${test_prefix}/cpp_cache2)

#Step 4:
