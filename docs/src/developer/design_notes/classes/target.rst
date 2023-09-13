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

******************
CMaizeTarget Class
******************

Base class for an entire hierarchy of build and install classes. Basic API
is found `here <https://raw.githubusercontent.com/CMakePP/CMaize/master/
docs/src/developer/overall_design.png>`__.

Modern CMake is target-based, meaning for CMaize to be able to interact
with CMake effectively CMaize will need to be able to generate CMake
targets. The ``CMaizeTarget`` class provides an object-oriented API for 
interacting with a CMake target. It also serves as code factorization for
functionality/APIs common to all target types. Native CMake only has one
type of target, which can be annoying since the target is interacted with
in different ways depending on what it describes. The classes which derive
from CMaizeTarget provide a more user-friendly means of interacting with 
specific target types than native CMake does.

For more information on target properties, see `Properties on Targets
<https://cmake.org/cmake/help/latest/manual/cmake-properties.7.html
#properties-on-targets>`__ in the `cmake-properties
<https://cmake.org/cmake/help/latest/manual/cmake-properties.7.html>`__
section of the CMake documentation.
