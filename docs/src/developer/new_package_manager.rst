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

   cpp_class(PIP PackageManager)
       # Class body goes here
   cpp_end_class()

For brevity, and to avoid this tutorial becoming dated, we omit the body of the
class. Developers should consult with the documentation for the base class,
i.e., ``PackageManager``, for details on what functions the derived class must
implement, and what those functions should do.

******************************
Registering the PackageManager
******************************

.. todo::

   This needs revisited. The current global variable approach seems hacky. There
   should probably just be some sort of initialization function.
