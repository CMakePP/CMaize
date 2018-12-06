.. _unit_test_helpers:label:

cpp_unit_test_helpers Module
============================

The cpp_unit_test_helpers Module contains functions to facilitate unit testing
CPP functions.

.. function:: _cpp_make_random_dir(<return> <prefix>)

   This function can be used to make a random directory under a particular
   prefix.  This is useful for when your unit test is going to generate files.
   In this case you want to keep your files separate from previous test runs.

   :param return: The full path to your random directory.  Use this path as your
     prefix throughout your test.

   :param prefix: The full path to the directory under which the randomly named
     directory will be created.

.. function:: _cpp_dummy_cxx_library(<prefix>)

   This function will create two files ``a.hpp`` and ``a.cpp`` that can be
   compiled into a library.  The files will be created under the specified
   directory.

   :param prefix: The full path to the directory that will contain the library's
     files.

.. function:: _cpp_dummy_cxx_package(<prefix> [NAME <name>])

   This function will not only write the source files for a C++ library, it will
   also generate the ``CMakeLists.txt`` that is required to build it.  Thus
   after calling this function the provided directory is a full-fledged CMake
   project.

   .. note::

      This function uses ``cpp_add_library`` and ``cpp_install`` and hence this
      function may not be suitable for factorizing code from tests of those
      functions.

   :param prefix:  The full path to where the files should be written.  The
       files will be in a sub-directory ``${prefix}/external/${name}``

   :param name: A name for the resulting CMake project.  Defaults to ``dummy``.

.. function:: _cpp_install_dummy_cxx_package(<prefix> [NAME <name>])

   This function wraps ``_cpp_dummy_cxx_package`` with the boilerplate for
   actually installing the resulting CMake package.

   :param prefix: Used to specify where the CMake project will go and also where
     it will be installed.  The former is ``<prefix>/external/<name>`` and the
     the latter is ``<prefix>/install``.

   :param name: The name to give the CMake project.  Defaults to ``dummy``.
