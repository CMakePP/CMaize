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

.. _designing_cmaizes_packagemanager_component:

###########################################
Designing CMaize's PackageManager Component
###########################################

TODO: Write me!!!


*****************************
PackageManager Considerations
*****************************

finding packages
   The design discussion in :ref:`designing_cmaizes_user_api` decided that the
   package manager would be responsible for finding packages that meet the
   specifications needed by the :term:`project`. From the
   :ref:`designing_cmaizes_cmaizeproject_component` discussion it was decided
   that the specifications will be represented by ``PackageSpecification``
   objects.

building packages
   The design discussion in :ref:`designing_cmaizes_user_api` decided that the
   package manager would be responsible for building packages that
   the :term:`project` depends on.

installing packages
   Brought up in :ref:`designing_cmaizes_cxx_target_classes`, the package
   manager is responsible for installing the built packages.
