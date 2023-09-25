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

.. _designing_cmaizes_target_component:

###################################
Designing CMaize's Target Component
###################################

TODO: Write me!!!

*******************************
Target Component Considerations
*******************************

.. _tc_language_specific:

language specific
   :ref:`designing_cmaizes_add_target_functions` required the language-specific
   aspects of target creation to be managed by the various target classes.

language agnostic
   While perhaps seemingly at odds with :ref:`tc_language_specific`, we also
   note that from the perspective of CMake and CMaize the language of the target
   is really only relevant in building the target.

dependency tracking
   :ref:`designing_cmaizes_cmaizeproject_component` established that each
   target will track the targets it depends on.
