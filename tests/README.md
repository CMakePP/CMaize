Unit Tests
==========

Unit testing is a critical part of the typical CI workflow.  Unfortunately, 
there isn't a whole lot of support for testing scripts/functions written in
the CMake language. This page briefly describes how we unit test as well as 
what the various unit tests test for.

Unit Testing Strategy
---------------------

For each unit test our strategy is to run CMake in scripting mode.  Thus the
`cpp_cmake_unit_test` simply tells `ctest` to run `cmake -P <script>` on the
script containing the unit tests.  Unit tests will be provided the toolchain 
file that was created when CPP was configured.  Unfortunately, in scripting mode
the `cmake` command will not auto-load the toolchain file and thus the first
line of every unit test will be `include(${CMAKE_TOOLCHAIN_FILE})`.  Once 
sourced,  this file adds the CPP submodules in the `CPP_ROOT/cmake` folder to 
the `CMAKE_MODULE_PATH` variable so they can be used from within tests.  It 
also allows tests to use whatever compilers were found when `CPP` was 
configured.  How each unit test proceeds from here depends on what that test is 
testing.

As a general rule all tests that generate files or build things will create 
those assets in a directory `${CMAKE_BINARY_DIR}/tests/<test_name>/<random_dir>`
where `test_name` is the name of the test as `ctest` sees it and `random_dir` is
a directory whose name is a random string.  Which random string is used for the
test is noted in the logs.  The use of the random string allows us multiple runs
of `ctest` without cleaning the build directory (particularly useful for CPP
development).  Tests that build assets are encouraged to include 
`cpp_unit_test_helpers.cmake` and to run the `_cpp_setup_build_env` macro before
doing anything.  In addition to creating the aforementioned asset directory, it
will also create a copy of the toolchain file that does not use the actual CPP
install cache, but rather one in the current asset directory (this avoids 
installing assets meant purely for testing into the user's cache).

### Simple Functions/Macros

For simple CMake functions it suffices to simply call them from the unit testing
script and compare the output/results to the expected output/result.  These
comparisons are done via a series of asserts that are defined in `cpp_checks`.
Failure of any assert raises a fatal error causing `ctest` to report the test as
failed.
  
