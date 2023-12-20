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
the "too long; didn't read (TL;DR)" summary.

*****
TL;DR
*****

- CMake is verbose. CMaize provides succinct stable, APIs.
- CMake features/best practices change a lot. CMaize's stable APIs allow the
  implementations to address these changes, without requiring CMaize users to
  update their build systems.
- CMaize supports package managers and languages CMake does not.
- CMaize is object-oriented and can be extended to even more package managers
  and languages, via inheritance.

****************
Full Description
****************

Generally speaking, most software packages require some setup before they can
be used. This setup is termed the :term:`build process` and executing the build
process is called "building". The :term:`build system` is the thing which
actually does the building. For C/C++ software, CMake has become
the de facto :cite:`cmake,cmake_cookbook,modern_cmake` :term:`build tool`
for managing the build process and most build systems are thus written using
the CMake scripting language.

Unfortunately, CMake-based build systems tend to be verbose and repetitive.
As gleaned from tutorials prominently showcasing boilerplate
code :cite:`cmake_cookbook,its_time_to_do_cmake_right,samples_for_moderncmake`,
the growing reliance on template repositories
:cite:`cmake_template,cpp_boilerplate,cppbase,cpp_lib_template,minimal_cmake_example,moderncpp_project_template,package_example`,
and even just copy/paste-ing CMake scripts from one project into another, the
broader community of CMake-based build system developer seem to have
accepted the verboseness and repetition (N.B. citations here are representative,
not exhaustive, i.e., we are aware that there are many more examples!). All of
these approaches to writing build systems run afoul of the
`"Don't Repeat Yourself (DRY)" <https://tinyurl.com/28x7h46c>`__ paradigm and
subsequently suffer from the same problems proponents of DRY seek
to avoid, *e.g.*, multiple sources of truth, lack of synchronization,
and coupling the logic of distinct units of code. The point is, *we need a way
to write CMake-based build systems, which does not violate DRY!*

The next problem with CMake-based build systems is that CMake's features and
best practices change quite readily. For example, up until CMake 3.11 in 2018
best practice was to write superbuilds :cite:`superbuild` for adding
dependencies to your project's CMake build system. CMake 3.11 introduced the
``FetchContent`` module, which in theory rendered superbuilds obsolete. In
practice, because many build systems had already been written in a manner that
precluded use with ``FetchContent``, many build systems needed to be rewritten.
With CMake 3.24 released in 2022, the best practices for dependency management
are again likely to change because now CMake natively supports package managers!
Another example is the switch to target-based build systems. Modern CMake is
target-based :cite:`modern_cmake,its_time_to_do_cmake_right`, but many of the
``FindXXX.cmake`` modules originally included with CMake 3.0 in 2014 were not;
instead the ``FindXXX.cmake`` modules set variables. Starting around CMake 3.5
this began to change as the ``FindXXX.cmake`` scripts now additionally made
targets. Many build systems adapted to the lack of targets before CMake 3.5 by
creating their own targets. Unfortunately, the targets the various build systems
created were not drop-in replacements for the targets that ``FindXXX.cmake``
started producing with CMake 3.5. The result was that build systems again needed
to be rewritten to adopt the new features.

While the CMake language is very backwards compatible (many core features
already existed in the CMake 2.X series), CMake-based build systems are
usually not forward compatible. The lack of forward compatibility is an issue
because CMake-based build systems are, by design, "viral". More specifically,
CMake works best if a project's dependencies also provide build systems written
in CMake, if the dependencies of those dependencies also utilize CMake-based
build systems, and so on and so forth. Unfortunately this also means that if a
project attempts to use a new feature, or a new best practice, that project's
dependencies must also support that feature or practice. Writing CMake-based
build systems can be a large time commitment and ideally *we need a series of
stable, forward compatible APIs for expressing our build system*, so that we
can avoid needing to rewrite CMake-based build systems every couple of years.

To be fair, a lot of the problems with CMake really stem from the lack of formal
build process standardization for the coding languages CMake targets (C/C++)
and supports (e.g., Fortran). For example C++ does not mandate how the
project's source is structured
:cite:`canonical_project_structure,gnu_layout,modern_cmake_layout`, nor does it
specify a standardized binary interface for libraries. In
an attempt to be able to support every build system, including those which may
involve tools yet to come, CMake has opted to assume as little as possible.
The result is CMake's functionality is very customizable, but at the cost of
also being very verbose. That said, even though the coding languages may
not impose formal standards on the build process, there are many aspects of the
process which are nearly standardized (or at worst there exists several
competing conventions). The point is, *there is a need to simplify the CMake
interface by targeting current best practices*. The resulting build tool would
be applicable to the majority of projects' build systems (and likely a strong
motivator for the remaining projects to follow suite).

Even though CMake strives to be as flexible as possible, the reality is that
software packages are becoming increasingly complicated as are their deployment
environments. For example, and as evidenced by the popularity of the pybind11
project :cite:`pybind11` on GitHub, many C/C++ packages are increasingly
supporting Python interfaces. Unsurprisingly, the Python interface often depends
on external Python packages, e.g., many scientific C/C++ projects leverage
Numpy :cite:`numpy`.
While CMake can already facilitate finding the Python interpreter and the
Python development libraries :cite:`find_python`, it is unreasonable to ask
CMake to also provide mechanisms for finding and building Python packages.
Furthermore, most
Python package maintainers are unlikely to provide CMake support. Admittedly,
the prevalence of the C++/Python paradigm may lead to CMake support down the
road, but the ultimate point we're trying to make is that it is unreasonable for
CMake to natively support all use cases of all coding languages. Instead,
*there is a need to be able to non-invasively extend CMake to additional coding
languages and package managers*.

Given that CMake is a full-featured coding language, it is possible to write
CMake extensions which will reduce the verbosity and redundancy via
abstractions. As already mentioned, this is not often done; instead many
projects resort to build system templates or copy/pasting. We speculate that the
primary hurdle to developing the desperately needed abstractions is a lack of
financial support and tooling. The CMake coding language is functional,
with a feel akin to shell scripting. In turn, for many modern programmers
developing software in CMake can be a laborious, aggravating process.
Particularly when it comes to developing scientific software, most financial
support targets science and not at software maintenance/sustainability. As a
result build systems are a low priority and many developers settle for
considerable technical debt in their build systems.

This is the state of C++ software development when CMake is used as a build
system. And this is why a project like CMaize is needed.
