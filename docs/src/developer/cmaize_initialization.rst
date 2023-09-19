.. _cmaize_initialization:

#####################
CMaize Initialization
#####################

The point of this page is to describe what happens when CMaize is initialized.

***********************
Initialization Sequence
***********************

CMaize initialization is triggered by the user including the top-level CMake
module, ``cmaize/cmaize.cmake`` via ``include(cmaize/cmaize)``.

1. Load ``cmaize_impl.cmake``. This entails:

   1. An early exit if ``cmaize_impl.cmake`` has already been loaded.
   2. Asserting the user is using a build directory.
   3. Defining CMaize `global configuration options <https://tinyurl.com/y63thveu>`__
   4. Bringing the CMaize classes, user API, and utility functions into scope.

2. Create a ``CMaizeProject`` for the most recent call to CMake's ``project``
   command.

   - The name of the project is read from ``${PROJECT_NAME}``

3. Set global rpath options including: ``CMAKE_SKIP_BUILD_RPATH``,
   ``CMAKE_BUILD_WITH_INSTALL_RPATH``, ``CMAKE_INSTALL_RPATH_USE_LINK_PATH``,
   and ``CMAKE_INSTALL_RPATH``.

***********
Other Notes
***********

- Initialization may end up happening many times. For example, if a project's
  dependencies also use CMaize, CMaize may be loaded multiple times.
- As a corollary of the previous point, CMaize's initialization should be kept
  short to avoid adding too much runtime overhead.
- Not using a build directory will cause CMake to contaminate the source code
  of the :term:`project`. Of particular note CMakePPLang will contaminate the
  source code with auto generated class bindings.
