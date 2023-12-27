.. Copyright 2023 CMakePP
..
.. Licensed under the Apache License, Version 2.0 (the "License");
.. you may not use this file except in compliance with the License.
.. You may obtain a copy of the License at
..
.. http://www.apache.org/licenses/LICENSE-2.0
..
.. Unless required by applicable law or agreed to in writing, software
.. distributed under the License is distributed on an "AS IS" BASIS,
.. WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
.. See the License for the specific language governing permissions and
.. limitations under the License.

##################################
How to Create a New PackageManager
##################################

.. note::

   This document is a work in progress.

************
Source Setup
************

The first step in creating a new package manager is creating the initial source
files for the package manager. CMaize stores package managers within the
``package_managers`` directory. Within ``package_managers``, each package
manager gets its own subdirectory. Source code for package managers tends to
be involved so we recommend separating the API of your package manager from its
implementation. To do this we create a file ``<package_manager_name>.cmake`` to
house the API and a subdirectory ``impl_`` which will house the implementation.
For example, source for the CMake package manager resides within the
``package_managers/cmake`` directory. The API lives in
``package_managers/cmake/cmake_package_manager.cmake`` (we wanted to avoid
the source file being called ``cmake.cmake``) and the implementations reside in
``package_managers/cmake/impl_``. Within the ``impl_`` directory you will create
one file per method (named after the method it implements) and a convenience
CMake module for including all of the implementations (the convenience module
is usually named ``impl_.cmake``). For example, the implementation of the CMake
package manager's ``install_package`` method resides in the file
``package_managers/cmake/impl_/install_package.cmake`` and the convenience
module is ``package_managers/cmake/impl_/impl_.cmake``. For completeness sake,
the contents of ``impl_.cmake`` look like:

.. code-block:: cmake

   include_guard()

   include(cmaize/package_managers/cmake/impl_/install_package)
   # include other method implementations here (recommend that modules are
   # included in alphabetic order)

To ensure that your new package manager is included when users load CMaize's
package manager component you will need to modify
``package_managers/package_managers.cmake`` so that it includes your new class.
For example, to ensure the CMake package manager is included,
``package_managers/package_managers.cmake`` will look like:

.. code-block:: cmake

   include_guard()

   include(cmaize/package_managers/cmake/cmake_package_manager)


****************************
Declaring the PackageManager
****************************

Now we write the API for our new package manager. For concreteness we assume
we are writing a class for Python's ``pip`` package manager. In this case the
API lives in ``package_managers/pip/pip.cmake`` and the contents of the file
look something like:

.. code-block:: cmake

   include_guard()

   include(cmaize/package_managers/package_manager)
   include(cmaize/package_managers/pip/impl_/impl_)

   cpp_class(PipPackageManager PackageManager)
       # Class body goes here
   cpp_end_class()

For brevity, and to avoid this tutorial becoming dated, we omit the body of the
class. Developers should consult with the
`documentation <https://cmakepp.github.io/CMaize/api/developer/cmaize/package_managers/package_manager.html>`_
for the base class, i.e., ``PackageManager``, for details on what functions the
derived class must implement, and what those functions should do.

******************************
Registering the PackageManager
******************************

.. todo::

   This needs revisited. The current global variable approach seems hacky. There
   should probably just be some sort of initialization function.

Most package managers will require additional dependencies beyond CMake. Thus
they should be off by default. When a user wants to use the package manager they
must explicitly enable it. This is done by writing an enable function. By means
of example, the ``enable_pip_package_manager`` function looks like:

.. code-block:: cmake

   function(enable_pip_package_manager)

      # 1. Tell the global environment that a pip package manager will exist
      cpp_get_global(_eppm_pms CMAIZE_SUPPORTED_PACKAGE_MANAGERS)
      if("pip" IN_LIST _eppm_pms) # If pip is in the list, it's already enabled
         return()
      endif()

      list(APPEND _eppm_pms "pip")
      cpp_set_global(CMAIZE_SUPPORTED_PACKAGE_MANAGERS "${_eppm_pms}")

      #2. Construct a PipPackageManater object
      find_package(Python3 COMPONENTS Interpreter QUIET REQUIRED)
      PipPackageManager(CTOR _eppm_package_manager "${Python3_EXECUTABLE}")

      #3. Register the PIP object with the global environment
      register_package_manager("pip" "${_eppm_package_manager}")

   endfunction()

The current convention is to implement the enable function after the class's
definition (so for pip the ``enable_pip_package_manager`` function will live
at the bottom of ``package_managers/pip/pip.cmake``). The last step is to
update ``cmaize_find_or_build_dependency`` so that it enables the package
manager if a user requests it. To do this look for the if/else tree comparing
``${_fobd_PACKAGE_MANAGER}`` against the list of package managers. Once found,
add a branch for your new package manager that calls the enable function you
just wrote.
