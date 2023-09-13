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
BuildTarget Class
*****************

This class represents a target which must be built as part of the build
system. It serves as an abstract base class for language-specific target
classes of supported languages that CMaize can build.

``BuildTarget`` includes the basic information needed to build a target,
including the paths and files needed to compile or import, project
specifications, and lists of dependencies that need to be built, along with
those that are already installed on the system. Additionally, it includes
general build functions that need to be overridden in children.
