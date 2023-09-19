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

.. _designing_cmaizes_cmaizeproject_component:

##########################################
Designing CMaize's CMaizeProject Component
##########################################

In :ref:`overview_of_cmaizes_design` we motivated the need for a
CMaizeProject component in order to track the state of the :term:`project`. This
page details the design process of the CMaizeProject component.

************************************
What is the CMaizeProject Component?
************************************

A :term:`build system` is written to direct a :term:`build tool` how to build
a :term:`project`. The CMaizeProject component is the part of CMaize
charged with representing the overall state of the :term:`project`. In practice,
a CMaizeProject will serve as a container for collecting the project's
configuration options, :term:`dependencies <dependency>`,
:term:`build targets <build target>`, and :term:`packaging <package>`
information.

*****************************************
Why Do We Need a CMaizeProject Component?
*****************************************

While CMake has a concept of a :term:`package`, CMake lacks the ability to
easily see the pieces of the :term:`project`. For example, at the time of
writing there is not a simple CMake function which returns a list of a
project's :term:`dependencies <dependency>`. Without a mechanism to query the
properties of a project, CMake relies on the user to resupply the same
information to a number of functions.

One of the main considerations for writing CMaize is
:ref:`minimizing the redundancy<minimize_redundancy>` found in typical
CMake-based :term:`build systems <build system>`. To this end, the CMaizeProject
component is designed to collect the the project's properties into a single
source of truth. With access to a project's properties it is easier for CMaize
to automatically propagate the project's information to multiple CMake
functions.

**************************************
CMaizeProject Component Considerations
**************************************

project state
   The purpose of the CMaizeProject component is to represent the state of
   the project. At a high level the list of project properties
   includes the:

   - ``PackageSpecification`` \
     (see :ref:`designing_cmaizes_packagespecification_component`),
   - :term:`dependencies <dependency>`, and
   - :term:`build targets <build target>`.

project-specific
   In :ref:`overview_of_cmaizes_design` we noted that designs need to account
   for the :ref:`recursive` consideration. For the CMaizeComponent this means:

   - Being able to have multiple instances of a ``CMaizeProject``.
   - Associating each ``CMaizeProject`` with a project relying on a
     CMaize-based build system.
   - Storing the ``CMaizeProject`` instances in a manner so that they can be
     retrieved given the active CMake project.
   - Being able to access ``CMaizeProject`` instances from higher/lower levels
     of recursion.

workspace
   The :ref:`cmake_based_build_system` consideration means that the user API of
   CMaize will rely on functional-style programming. Under the hood, we will
   store the objects associated with the active project in a ``CMaizeProject``
   object. Thus many functions are implemented using a pattern of:

   1. Retrieve the active ``CMaizeProject``.
   2. Use the objects in the active ``CMaizeProject`` to complete a task.
   3. If necessary, update the objects in the active ``CMaizeProject``.
   4. Save the active ``CMaizeProject`` in such a manner that this process can
      be repeated.

   Subject to such a workflow, the ``CMaizeProject`` object takes on a
   workspace-like role.

*************************************
Design of the CMaizeProject Component
*************************************

TODO: Left off here.
