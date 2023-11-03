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
CMaize Conventions
******************

This section describes the conventions to be followed when developing
for CMaize. Since CMaize is based on CMakePPLang, an object-oriented
extension to the CMake language, CMaize developers should follow the same
conventions set forth by `the CMakePPLang conventions 
<https://cmakepp.github.io/CMakePPLang/conventions.html>`__, unless otherwise
specified here.

Namespaces
==========

The CMakePPLang uses the prefixes ``cpp_``, ``_cpp_``, and ``__cpp_`` to
specify namespaces to specify public API, protected, and private commands,
as well as ``CMAKEPP_LANG_``, ``_CMAKEPP_LANG_``, and ``__CMAKEPP_LANG_`` for
for variables in the same scopes. CMaize adopts a similar convention, using
the prefixes ``cmaize_``, ``_cmaize_``, and ``__cmaize_`` for commands and
``CMAIZE_``, ``_CMAIZE_``, and ``__CMAIZE_`` for variables.

Note that commands in native CMake (as well as CMakePPLang) are
case-insensitive, so the ``CMAIZE_`` prefix on a command is still the same
namespace as ``cmaize_``. However, variables are case-sensitive, so care needs
to be taken not to overlap variables and commands with the same names.
