.. _additional_resources:label:

Additional Resources
====================

This is a collection of additional resources on things associated with CPP that
may prove useful to other developers.

CMake
-----

These are resources specifically targeting CMake usage

* `It's Time to Do CMake Right <https://pabloariasal.github.io/2018/02/19/its-time-to-do-cmake-right/>`_

  This is one of the most concise primers on modern CMake I know of.  It also
  forms the basis for much of CPP.  Assuming you're familiar with the basics of
  CMake it's probably a 15/20 minute read.  If that's too long of a read here
  are the take home points:

    * Modern CMake uses targets not variables for components of the project
    * ``CMAKE_CXX_FLAGS`` should not be touched
    * Dependencies use ``target_link_libraries``
    * Projects should export their targets

      * If your project's dependencies don't export their targets it's a bug
      * If your dependency won't fix their bug you need to write a `Find` file

    * Config file should import the exported targets
