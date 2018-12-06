.. _unit_testing-label:

Unit Testing
============

This page contains information related to unit testing the CPP project. Given
that unit testing is a critical part of the typical CI workflow it should come
as no surprise that we want to unit test CPP. Unfortunately, there isn't a whole
lot of support for testing scripts/functions written in the CMake language. This
is why we have dedicated an entire page to our unit testing practices.

Unit Testing Strategy
---------------------

All unit tests are contained within ``CMakePackagingProject/tests``.  The
``CMakeLists.txt`` adds our tests to CTest using the CPP CMake modules in the
``CMakePackagingProject/cmake`` directory, *i.e.*, any changes made to a module
are immediately reflected in the test.  The ``CMakeLists.txt`` itself is
straightforward.  We append make sure CMake can find the CPP modules, define a
list of tests, and then register those tests with CTest.  The tests themselves
are run by invoking CMake in scripting mode.  This means if the test uses more
than control logic and/or the most basic of CMake commands it'll have to be
wrapped in a call to the :ref:`_cpp_run_sub_build-label` function.

Some basic unit testing functions are available in the
``cpp_unit_test_helpers.cmake`` module; documentation for these functions can be
found at :ref:`cpp_unit_test_helpers-label`.  Note that at the moment this
module is copied to the testing directory as part of the configuration.
Consequentially, any modifications to this file require configuration to be
rerun.  The idea behind this approach is that this module is not part of CPP
proper and hence we do not want it being installed with CPP (like it would be if
it were in the ``CMakePackagingProject/cmake`` directory).

Our unit testing functionality is rather primitive.  In particular we do not
have an actual framework.  What this means is that it is better to have many
unit test files, rather than one file per CPP module.  The reason is this
provides a more descriptive nature of the error.  We recommend that each
function gets its own unit test file so that it is immediately clear which
functions are broken vs. which modules.
