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

This page records the design process of CMaize's target component.

.. _tc_what_is_cmaizes_target_component:

**********************************
What is CMaize's Target Component?
**********************************

CMaize's target component contains classes which represent traditional CMake
:term:`build targets<build target>`. CMaize's target component is an object-
oriented take on the functional approach to managing targets provided by
traditional CMake.

*****************************************
Why Do We Need CMaize's Target Component?
*****************************************

Since CMake already provides native support for targets, arguably the more
pertinent question is: "Why do we need an object-oriented target component?".
The original motivation  was to manage
complexity, while still providing a user-friendly interface. As suggested by
the length of the CMake target `documentation <https://tinyurl.com/535scwpn>`__,
there are many considerations which go into properly setting up a CMake target.
CMaize targets are designed
to manage those considerations via a separation of concerns. For example,
users creating a target for a C++ executable, via the ``CXXExecutable`` class
need only interact with target properties which are relevant for executables,
whereas the native CMake :term:`API` additionally exposes many other
considerations including: libraries, object libraries, and alias targets.
Another motivation for CMaize's target component is to wrap the process of
getting/
setting target properties in a more user-friendly interface (CMake's native
API can be a bit of a pain because it depends on exactly what the target
represents).

Another motivation for CMaize's target component is to extend CMake targets to
other coding languages. Out of the box, CMake targets are primarily meant for
use with C/C++ targets. Modern C/C++ projects often contain pieces written in
other coding languages, notably Python. Being able to treat these additional
project pieces, with a unified build system, decreases the project management
burden since maintainers do not need to learn multiple build systems.

*******************************
Target Component Considerations
*******************************

In designing CMaize's target component we have considered:

.. _tc_language_specific:

language specific
   From the discussion on  :ref:`designing_cmaizes_add_target_functions`, it
   was decided that the language-specific aspects of target creation would be
   managed by a target class hierarchy residing below the user :term:`API`.

.. _tc_language_agnostic:

language agnostic
   While perhaps seemingly at odds with :ref:`tc_language_specific`, we
   note that from the perspective of CMake, and CMaize, targets serve primarily
   as nodes in a :term:`DAG`. The language of the target is not relevant for
   assembling the DAG and it should thus be possible to work with already
   created targets in a language agnostic manner.

.. _tc_dependency_tracking:

dependency tracking
   From discussions on :ref:`designing_cmaizes_cmaizeproject_component` we
   established that each target will need to track the targets it depends on.

   - As a corollary we note that tracking dependencies is used for establishing
     build order.
   - For a working installed package we know that all dependencies have already
     been satisfied (otherwise the package would not currently be working).
     Downstream consumers of a working installed package do not need to track
     the package's dependencies because the package already does this for them.

.. _tc_cmake_based_targets:

cmake based targets
   Modern CMake is target-based. Since CMaize relies on CMake, CMaize will need
   to track the underlying CMake target(s).

.. _tc_lazy_cmake_target_creation:

lazy cmake target creation
   Somewhat of a corollary to the :ref:`tc_cmake_based_targets` consideration,
   we note that defining a CMake target requires some of its state to already be
   known, e.g., we need to know all of the source files for a C++ executable.
   The required state will in general live in language-specific derived classes
   and may be set over a number of manipulations. To accommodate such a
   workflow, we require that the CMake target can be created lazily, i.e., the
   CMake target is only created when needed.

   - This consideration applies to build targets, since already installed
     targets are required to know all of their state immediately.

***********************************
Design of CMaize's Target Component
***********************************

.. _fig_cmaize_targets:

.. figure:: assets/targets.png
   :align: center

   The overall architecture of CMaize's target component. Also shown are the
   API details of the language agnostic pieces.

:numref:`fig_cmaize_targets` provides an overview of the architecture of
CMaize's target component. Stemming from the :ref:`tc_language_specific` and
the :ref:`tc_language_agnostic` considerations the class hierarchy is seen as
having a language-agnostic piece and a language-specific piece. The base
``CMaizeTarget`` class and its two child classes,
``BuildTarget`` and ``InstalledTarget``, define the language agnostic piece of
the hierarchy. The opaque elements of :numref:`fig_cmaize_targets`, i.e., those
labeled ``CXX Targets``, ``Python Targets``, and ``CMake Targets``, form the
language-specific part of the target component. The design of the classes needed
to support targets for each coding language can be found elsewhere (see
:ref:`designing_cmaizes_cxx_target_classes`,
:ref:`designing_cmaizes_python_target_classes`, and
:ref:`designing_cmaizes_cmake_target_classes` respectively).

The corollary of consideration :ref:`tc_dependency_tracking` means CMaize
only needs to track dependencies for targets the build system will build; this
is the motivation for the split between ``BuildTarget`` and ``InstalledTarget``.
Code factorization --- including consideration :ref:`tc_cmake_based_targets`,
which means all CMaize targets must have corresponding CMake targets --- is
the motivation for the common base class ``CMaizeTarget``. To address
:ref:`tc_lazy_cmake_target_creation` the ``BuildTarget`` class has a virtual
function ``make_target``. Calling ``make_target`` triggers the creation of
the CMake target.

*******
Summary
*******

:ref:`tc_language_specific`
   A subset of the classes comprising CMaize's target component are dedicated
   to representing language-specific targets.

:ref:`tc_language_agnostic`
   The ``CMaizeTarget``, ``BuildTarget``, and ``InstallTarget`` classes contain
   the common functionality needed to interact with all targets, regardless of
   the coding language.

:ref:`tc_dependency_tracking`
   The ``BuildTarget`` class contains a member which tracks the target's
   dependencies. ``BuildTarget`` is intended for use with targets CMaize will
   build.

:ref:`tc_cmake_based_targets`
   All classes in CMaize's target component ultimately inherit from the
   ``CMaizeTarget`` class. The ``CMaizeTarget`` class houses the CMake target
   associated with the object.

:ref:`tc_lazy_cmake_target_creation`
   ``BuildTarget`` defines a virtual function ``make_target`` which,
   when called, will actually create the associated CMake target.
