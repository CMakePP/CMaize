##############
Other Projects
##############

.. warning::

   The discussions of other projects provided on this page are largely based off
   of first impressions gleaned from project websites and documentation. It is
   possible that this page does not accurately reflect the state of the listed
   projects. We are happy to update this page if discrepancies are brought to
   our attention.

.. note::

   Subject to the above warning, note that each description was accurate as of
   the time of writing. The CMaize team does not actively monitor other
   projects and thus circumstances may have changed. If you are aware of any
   of these descriptions no longer being accurate, feel free to open an issue
   on CMaize's GitHub page (or better yet, a pull request) detailing the
   necessary updates.

This page discusses other projects which, in some shape or form, attempt
to address the same needs as CMaize (see :ref:`statement_of_need`). As described
in more detail on the :ref:`overview_of_cmaizes_design` page, we feel the ideal
solution should:

1. :ref:`cmake_based_build_system`
2. :ref:`cmake_based_workflows`
3. :ref:`minimize_redundancy`
4. :ref:`target_support`
5. :ref:`package_manager_support`
6. :ref:`object_oriented`
7. :ref:`recursive`
8. Be actively supported.

The following table summarizes how well each existing project addresses these
design constraints (column numbers correspond to the above list):

.. |y| replace:: ✅
.. |n| replace:: ❌
.. |?| replace:: ❔

+--------------+-----+-----+-----+-----+-----+-----+-----+-----+
|              |               Features Supported              |
| Project Name +-----+-----+-----+-----+-----+-----+-----+-----+
|              |  1  |  2  |  3  |  4  |  5  |  6  |  7  |  8  |
+--------------+-----+-----+-----+-----+-----+-----+-----+-----+
| Autocmake    | |n| | |n| | |y| | |y| | |n| | |n| | |?| | |y| |
+--------------+-----+-----+-----+-----+-----+-----+-----+-----+
| BLT          | |y| | |y| | |y| | |y| | |n| | |n| | |?| | |y| |
+--------------+-----+-----+-----+-----+-----+-----+-----+-----+
| Cinch        | |n| | |y| | |y| | |?| | |n| | |n| | |y| | |n| |
+--------------+-----+-----+-----+-----+-----+-----+-----+-----+
| CMake\+\+    | |y| | |y| | |y| | |y| | |y| | |y| | |y| | |n| |
+--------------+-----+-----+-----+-----+-----+-----+-----+-----+
| Hunter       | |y| | |y| | |n| | |y| | |y| | |n| | |y| | |y| |
+--------------+-----+-----+-----+-----+-----+-----+-----+-----+
| JAWS         | |y| | |y| | |y| | |y| | |n| | |n| | |?| | |n| |
+--------------+-----+-----+-----+-----+-----+-----+-----+-----+

Each of the following sections provides a brief discussion of the other
projects. For each project we provide the:

Website
   This is a link to the project's website or documentation (if we can find it).

Source
   For open-source projects this is a link to the where the source code of the
   project can be obtained.

Development status
   We consider a project "active" if there has been a commit in the last year.
   Otherwise the project is listed as "inactive".

User community
   This is an attempt to summarize whether a project is actually being used.
   We define three levels: none, small, and large. A user community of "none"
   means that the project is primarily used by the developers. "small" indicates
   that the project seems to have some external interest. Whereas "large"
   indicates that the project appears to be actively utilized by a number of
   external users. For GitHub projects we use 100 watchers and/or stars as the
   cut-off between small and large.

Finally, we note that projects are listed in alphabetical order.

*********
Autocmake
*********

- Website: `<http://autocmake.org/>`_
- Source: `<https://github.com/dev-cafe/autocmake>`_.
- Development status: active.
- User community: small.

The motivation for Autocmake :cite:`autocmake` was to avoid copy/pasting CMake
build systems
across projects and instead generate them from a configuration file. Autocmake
is written in a mix of Python and CMake. The Python parts focus on the
generation, whereas the CMake modules largely focus on finding specific
dependencies (e.g., there are CMake modules for Boost, Python, GoogleTest),
though there are also some which provide useful features (e.g, colored CMake
messages, and a safe guard for avoiding in-source builds).

Ultimately, the use of the generator means that projects which use Autocmake
suffer from the problems described :ref:`here <why_not_a_generator>`. The
documentation also suggests (see `here <https://tinyurl.com/mr49kffb>`__ for
example) that parts of the build system are Python-based, and that users can not
use established CMake workflows. We were not able to readily identify if
projects which use Autocmake can have dependencies which also use Autocmake,
though we suspect that recursion IS allowed.

***
BLT
***

- Website: `<https://llnl-blt.readthedocs.io/en/develop/>`_
- Source: `<https://github.com/llnl/blt>`_
- Development status: active.
- User community: large.

BLT :cite:`blt` appears to stand for "Build, Link, and Test", though the README
suggests
there can be "-ing" suffixes as well. BLT is designed to make it easy to
declare libraries/executables and link them to dependencies commonly encountered
in :term:`HPC`. Since it's native CMake, users can further customize their
build system by writing their own CMake infrastructure.

Ultimately, BLT is probably very useful if you want to build an :term:`HPC`
application, with minimal dependencies (aside from those found in the standard
:term:`HPC` toolkit). However, BLT provides very minimal support for finding
other dependencies, and as far as we can tell, no support for building other
dependencies. That said, the size of the user community suggests that, despite
these limitations there is quite a bit of demand for BLT.

*****
Cinch
*****

- Website: N/A
- Source: `<https://github.com/laristra/cinch>`_
- Development status: inactive.
- User community: small.

Like other projects on this page, Cinch :cite:`cinch` is designed to cut back
on the amount of coding needed to write a CMake-based build system. The
documentation is a bit sparse, but it appears that Cinch provides CMake bindings
that wrap a Python tool
`cinch-utils <https://github.com/laristra/cinch-utils>`_. The build system
developer then writes a CMake-based build system in terms of the CMake bindings.

In terms of features, Cinch seems to be primarily interested in support
facilitating the building of libraries and executables as well as unit tests
and documentation for the libraries and executables. Cinch seems to assume that
the source tree also contains the dependencies' source, and relies on recursive
builds to create the final package. Additional package management appears to be
limited to calling ``find_package``. Finally, Cinch also contains a seemingly
out of place C++ logging system. The latter in particular makes this project
feel like it was targeting a particular group's workflow, rather than being
meant as general tool.

*******
CMake++
*******

- Website: N/A.
- Source: `<https://github.com/toeb/cmakepp>`_
- Development status: inactive.
- User community: large.

CMake++ is a tour-de-force of what is possible with the traditional CMake
language. At its core, CMake++ is meant to be more of a library for CMake,
then a build system. That said it does contain a number of features which can
be used to simplify writing build systems including native dependency
management support. While CMake++ would have been an excellent starting point
for CMaize, the CMake++ project has been abandoned and lacks documentation
(except for high-level functionality); in turn complicating the process of
resurrecting CMake++.

******
Hunter
******

- Website:
- Source: `<https://github.com/cpp-pm/hunter>`_
- Development status: active.
- User community: large.

Hunter is a package manager written in CMake, meant to integrate directly into
a CMake build system. On its surface Hunter is great; however, after
experimenting with Hunter we ran into a few problems. The largest problem was
that Hunter is very tied to its internal set of packages. This makes it very
difficult to use pre-built dependencies or dependencies Hunter does not know
how to build. Another problem is that Hunter only partially alleviates the
verbose and repetitive nature of CMake. More specifically, the process of
writing a build recipe for a new package is roughly the same as writing a
CMake-based build system for that package. Repetition is avoided by having the
build systems all live in the same repo (a repo maintained by the Hunter
package manager).


****
JAWS
****

- Website: N/A
- Source: `<https://github.com/DevSolar/jaws>`_
- Development status: inactive.
- User community: none.

JAWS :cite:`jaws` stands for "Just A Working Setup". As the name suggests, JAWS
expects you to copy/paste it into your project and go from there. Under the
hood JAWS does some things for you, like keeping the project's name and version
consistent throughout files, finding common dependencies (e.g., Boost, LaTeX,
and Doxygen), and setting up tests.

Since JAWS relies on essentially copying/pasting source it suffers from the
same problems (see :ref:`why_not_copy_paste`). Like some of the other projects
on this list, JAWS's coupling to a stack of specific dependencies makes JAWS
feel less like a general solution, and more like it was targeted at a specific
group.
