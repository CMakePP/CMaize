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

*****************
Advanced Building
*****************

While CMaize strives to make building a project easy, power users and
developers will likely want more control over the project they are building.
This section highlights some advanced build system features.

Toolchains
==========

These files are forwarded to CMake via the ``CMAKE_TOOLCHAIN_FILE`` variable.
Particularly when you are setting a lot of options for CMake these files can
come in handy.  Basically they look like:

.. code-block:: cmake

   set(OPTION1 VALUE1)
   set(OPTION2 VALUE2)

That is they're just a large number of CMake ``set()`` commands. It is common
practice to assemble toolchain files per platform and share these files with
users to facilitate building.

Offline Builds
==============

Ultimately when CMaize can not locate a dependency it will retrieve that
dependency using CMake's ``FetchContent`` module. In turn, it is possible to
pre-download dependencies and build a CMaize project entirely offline. To do
this you will need to set ``FETCHCONTENT_FULLY_DISCONNECTED`` to ``TRUE`` and
tell CMake where to look for each dependency's source code. For a dependency
*foo*, set the variable ``FETCHCONTENT_SOURCE_DIR_FOO`` to the path to
*foo*'s source code.

Developing Across Multiple CMaize Projects
==========================================

Say you have two projects *A* and *B* such that *B* uses features in
*A*. It often is the case that you need to add a feature to *A* to use in
*B* (or correct a bug in *A* so that *B* works). In a traditional workflow
this would require modifying *A*, pushing the changes, and then rebuilding
*B* with those changes (possibly needing to muck with *B*'s
``CMakeLists.txt`` while the feature in *A* is in development still).
``FetchContent`` helps here too. Now you just set ``FETCHCONTENT_SOURCE_DIR_A``
to your local copy of *A* and rebuild *B*. CMake is smart enough to rebuild
*B*'s version of *A* if you further modify *A*.
