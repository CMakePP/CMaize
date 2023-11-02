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

.. _statement_of_need:

#################
Statement of Need
#################

This page summarizes why we wrote CMaize. For convenience we start with the
the "too long; didn't ready (TL;DR)" summary.

*****
TL;DR
*****

- CMake is verbose. CMaize provides succinct stable, APIs.
- CMake features/best practices change a lot. CMaize's implementations address
  these changes, without requiring CMaize users to update their code.
- CMaize supports package managers and languages CMake does not.
- CMaize is object-oriented and extendable via inheritance.

****************
Full Description
****************

Generally speaking, most software packages require some setup before they can
be used. This setup is termed the :term:`build process` and executing the build
process is called "building". The :term:`build system` is the thing which
actually does the building. For C/C++ software, CMake has become
the de facto  :term:`build tool`  :cite:`cmake,modern_cmake` for managing the
build process and most build systems are thus written using the CMake scripting
language.

Unfortunately, CMake-based build systems tend to be verbose and repetitive.
As gleaned from tutorials prominently showcasing boilerplate
code :cite:`its_time_to_do_cmake_right,samples_for_moderncmake`, the growing
reliance on template repositories :cite:`cmake_template,cpp_boilerplate,cppbase,cpp_lib_template,minimal_cmake_example,moderncpp_project_template,package_example`,
and even just copy/paste-ing CMake scripts from one project into another the
broader community of CMake-based build system developer seem to have just
accepted the verboseness and repetition (N.B. citations here are representative,
not exhaustive, i.e., we are aware that there are many more examples!). All of
these approaches to writing build systems run afoul of the
`"Don't Repeat Yourself (DRY)" <https://tinyurl.com/28x7h46c>`__ paradigm and
subsequently suffer from the same problems proponents of DRY seek
to avoid, *e.g.*, multiple sources of truth, lack of synchronization,
and coupling the logic of distinct units of code. The point is, *we need a way
to write CMake-based build systems, which does not violate DRY!*

The next problem with CMake-based build systems are that CMake's features and
best practices change quite readily. For example, up until CMake 3.11 in 2018
best practice was to write superbuilds :cite:`superbuild` for adding
dependencies to your project's CMake build system. CMake 3.11 introduced the
``FetchContent`` module, which in theory rendered superbuilds obsolete. In
practice, because many build systems had already been written in a manner that
precluded use with ``FetchContent``, many build systems needed to be rewritten.
With CMake 3.24 released in 2022, the best practices for dependency management
are again likely to change because now CMake natively supports package managers!
Another example is the switch to target-based build systems. Modern CMake is
target-based :cite:`moder_cmake,its_time_to_do_cmake_right`, but many of the
``FindXXX.cmake`` modules originally included with CMake 3.0 in 2014 were not;
instead the ``FindXXX.cmake`` modules set variables. Starting around CMake 3.5
this began to change as the ``FindXXX.cmake`` scripts now additionally made
targets. Many build systems adapted to the lack of targets before CMake 3.5 by
creating their own targets. Unfortunately, the targets the various build systems
created were not drop-in replacements for the targets that ``FindXXX.cmake``
started producing with CMake 3.5. The result was that build systems again needed
to be rewritten to adopt the new features.

While the CMake language is very backwards compatible (well into the CMake 2
series in many cases), build systems are
usually not forward compatible. The lack of forward compatibility is an issue
because CMake-based build systems are, by design, "viral". More specifically,
CMake works best if a project's dependencies also provide build systems written
in CMake, if the dependencies of those dependencies also utilize CMake-based
build systems, and so on and so forth. Unfortunately this also means that if a
project attempts to use a new feature, or a new best practice, that project's
dependencies must also support that feature or practice. Writing CMake-based
build systems can be a large time commitment and ideally *we need a series of
stable, forward compatible APIs for expressing our build system*, so that we
can avoid rewriting build systems every couple years.


To be fair, a lot of the problems of


Given that CMake is a full-featured coding language, it is possible to write
abstractions as CMake extensions which will reduce the verbosity and redundancy,
but this is not often done. We speculate that the primary hurdle to developing
such abstractions is lack of support. Most support for scientific software is
aimed at method development and not at software maintenance/sustainability. As
a result build systems are a low priority. This is why CMaize is needed. CMaize
will be a reusable, :term:`build tool` built on top of CMake designed to
streamline writing build systems, particularly build systems of scientific
software.

- Consistency. CMake best practices evolve somewhat quickly
  - Superbuilds
  - C++ feature lookup
  - FetchContent compatible
  - Dependency providers
