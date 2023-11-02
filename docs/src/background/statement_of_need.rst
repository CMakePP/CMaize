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

- CMake is verbose, CMaize strives to be as succinct as possible.
- CMake best practices often amount to copy/pasting from another build system.
  CMaize's minimal APIs avoid this problem and propagate information
  programatically.
- CMaize has stable APIs. Support for new CMake features/best practices is done
  under the hood.
- CMaize can be extended to new use cases via inheritance.
- Other similar tools are no longer supported.
- CMaize is easy (or at least we think so).

****************
Full Description
****************

Generally speaking, most software packages require some setup before they can
be used. This setup is termed the :term:`build process` and executing the build
process is called "building". Building a package typically, at a minimum,
requires ensuring that all necessary dependencies are installed and available
so that the software can actually be run. For compiled software, one must not
only manage external dependencies, but also internal dependencies among source
files, i.e., the source files can be considered dependencies of the binary
objects needed for the software to run. Thus, at a high-level, building software
is an exercise in dependency management.

For C/C++ software, CMake has become the de facto tool for managing the build
process. Unfortunately, the vast majority of build systems leveraging CMake are
verbose
and highly redundant. Generally speaking, it seems that the broader
CMake community has accepted that this "is simply the way CMake build systems
are" and has stopped trying to improve them. Evidence for this claim comes from
tutorials prominently showcasing boilerplate code,
the growing reliance on template repositories (more or less version-controlled
copy/pasting) :cite:`cmake_template,cpp_boilerplate,cppbase,minimal_cmake_example,moderncpp_project_template,package_example`,
and even just copy/paste-ing CMake scripts from one project
into another. Note that citations supporting this evidence are representative,
not exhaustive, i.e., we are aware that there are many more examples!

All of these approaches run
afoul of the
`"Don't Repeat Yourself (DRY)" <https://tinyurl.com/28x7h46c>`__ paradigm and
subsequently suffer from the same problems proponents of DRY seek
to avoid, *e.g.*, multiple sources of truth, lack of synchronization,
and coupling the logic of distinct units of code.

Another problem with CMake is that features and best practices are constantly
changing. While the CMake language is fairly backwards compatible, the
build systems written in CMake usually are not. This is because CMake-based
build systems have a "viral" tendency. More specifically, CMake works best if
a project's dependencies also provide build systems written in CMake, and if the
dependencies of those dependencies also utilize CMake-based build systems, so on
and so forth. In such a case, CMake is able to manage dependencies across
projects. Unfortunately this also means that if a project attempts to use a new
feature, or a new best practice, that project's dependencies must also support
that feature or practice.


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
