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
   3. Defining CMaize
      `global configuration options <https://tinyurl.com/y63thveu>`_
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
