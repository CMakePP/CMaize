..
   Copyright 2023 CMakePP

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.

###########
Quick Start
###########

Projects using CMaize are encouraged to use this page as their build
documentation, so if you're seeing this page odds are the package you're trying
to build uses CMaize for their build.  If you are a complete CMake newbie
(there's nothing wrong with that, we all were at some point) check out the
:ref:`quick_introduction_to_cmake` page to get acclimated.

Step 0: Obtain CMaize
=====================

Packages which use CMaize are encouraged to make their build system download
CMaize and include it. If the package you are using does not do this you will
need to manually download CMaize yourself and ensure that ``CMAKE_MODULE_PATH``
points to the ``cmake`` directory in the downloaded repository.

Step 1: Build the Project
=========================

We'll assume that the source code for the package you are trying to build is
located in the directory ``package_dir``.  Configuring, building, and installing
a package which uses CMaize is done with the following commands:

.. code-block:: bash

   cd package_dir
   cmake -H. -B<build_dir> -D<Option1>=<value> ...
   cmake --build <build_dir>
   cmake --build <build_dir> --target install

There are a lot of possible options for configuring the package, thus we
strongly suggest you check out :ref:`cmake_option_variables` for
a list of the more important considerations. If you are setting more than
``CMAKE_PREFIX_PATH`` and/or ``CMAKE_INSTALL_PREFIX`` it is strongly recommended
that you use a toolchain file to record the options and save yourself time later
if you need to rerun the `cmake` command.

Troubleshooting
===============

While we've striven to make CMaize as foolproof as possible, the reality is
bugs do occur and sometimes you build can get locked in a stale state.  Thus if
a build fails we recommend you consider the following tips:

* Ensure you have provided CMake with all options required by the package

  * Consult the package's documentation for a list of all such options

* Try deleting your build directory and rebuilding

  * CMake does a great job of determining when it needs to regenerate or modify
    a file, but it gets stuck some times.

* If the dependency you are building is hosted on a private GitHub repository
  then you will need to set :term:`CMAIZE_GITHUB_TOKEN` to a valid token.

  * The token needs to be generated to minimally have read access to the
    repository.
  * See :term:`CMAIZE_GITHUB_TOKEN` for more information on generating tokens.

If your problem still persists check out our page
:ref:`faqs_and_common_build_problems` to see if this a common problem.
Finally, if you still can not resolve the problem consider opening an issue on
CMaize's GitHub repo (please look to see if an issue already exists before
opening a new one).
