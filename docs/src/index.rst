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

######
CMaize
######

CMaize is the top-level project of the CMakePP organization. It is this project
which package maintainers should use to write their projects' build systems.
Consequently, CMaize's documentation is the documentation to consult for
generic help when it comes to building a project that uses CMaize.

Users that want to create a new project using CMaize for their build system
should check out the :ref:`Overview of CMaize and its features<overview>`,
the guide to
:ref:`using_cmaize_as_your_build_system`, and
CMaize's :ref:`api` documentation. These sections contain the information
you'll need to get started using CMaize with your project.

If you are attempting to build an existing project that uses CMaize please see
:ref:`building_a_project_that_uses_cmaize`.
This section contains a guide on building projects that use CMaize, solutions
to common problems, and details on more advanced build features.

Information for developers looking to help develop CMaize can be found in
:ref:`developing_cmaize`.

.. toctree::
   :maxdepth: 2
   :caption: Contents:

   overview
   background/index
   getting_started/index
   api/index
   developer/index
   declaring_targets/index
   dependencies/index
   bibliography/bibliography
