.. _targets-label:

Registering Targets with CPP
============================

Targets are the parts of your project that need to be built.  They may or may
not be part of the final package.  Typically targets are either a library or an
executable.

Libraries
---------

To add a library to CPP use the ``cpp_add_library`` command (note the ``cpp``
prefix, this is a wrapper around CMake's ``add_library`` that is aware of the
CPP dependency manager).  For a typical library the usage is:

.. code-block:: cmake

   cpp_add_library(
       my_library
       SOURCES source1.cpp source2.cpp ...
       INCLUDES include1.hpp include2.hpp ...
       DEPENDS depend1 depend2 depend3
   )

That is to say you give the library a name (this should be the name of the
library without the prefix or suffix, *e.g.*, without the "lib" and ".so"/".a"
on Unix-like platforms), list the source files to compile to make the library,
the **public** header files associated with the resulting library, and the
targets the library depends on.  Note that calling this command does not
automatically register the library for installation.

Full API details can be found at :ref:`cpp_add_library-label`.

Executables
-----------

Executables are registered with CPP analogous to libraries:

.. code-block:: cmake

   cpp_add_executable(
      my_executable
      SOURCES source1.cpp source2.cpp ...
      DEPENDS depend1 depend2 depend3 ...
   )

From the user's perspective, aside from the different function name, the only
difference is that executables never have public header files.

Full API details can be found at :ref:`cpp_add_executable`.


Packaging Targets
-----------------

After you have registered all your targets with CPP you need to pick which ones
you want to install.  This is done with the ``cpp_install`` command.  Usage is:

.. code-block:: cmake

   cpp_install(TARGETS target1 target2 ...)

This will package up your project with the various components serving as
components of your package.  This takes care of writing the CMake config files,
as well as moving the headers and libraries.  Generally speaking you should not
install any targets that represent tests.
