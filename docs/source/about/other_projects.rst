.. _other_projects-label:

Other Relevant Projects
=======================

In order to put CPP in perspective this section describes some other relevant
projects. The maintainers of CPP do not actively keep tabs on the projects
listed here so this information may not be up to date. Instead consider this
page a snapshot of the field at the time writing of CPP started. The projects
are listed in alphabetic order.

Autocmake
---------

`Autocmake's home <https://github.com/dev-cafe/autocmake>`_.

Autocmake takes the meta-build system to the next level (hyper build system?) by
generating ``CMakeLists.txt`` on-the-fly. To use Autocmake in a package, the
package maintainer encodes their package's requirements into a
``autocmake.yml`` file. The package maintainer then uses Python to generate the
necessary ``CMakeLists.txt`` for the package. Autocmake also generates an
optional ``setup`` script which provides a Python API around the actual CMake
commands required for building the package.

From the ``*.yml`` file the package maintainer can:

* set the name of the project,
* set the language of the project,
* specify minimum required CMake,
* add build options,
* specify the CMake modules to include, and
* set environment variables

Autocmake is really intended as a more elegant solution for setting up a new
CMake-base build system than the typical copy/paste commonly in use. The
resulting build system only contains the surface logic for interacting with the
user trying to build the package. Actually finding/building dependencies,
packaging the project, *etc.* must still be implemented by the package
maintainer using native CMake constructs. If the package maintainer implements
CMake modules for performing these tasks, then Autocmake is capable of easily
synchronizing those modules across other projects. Unfortunately, at least at
the time of this writing, the CMake modules included with Autocmake are
primarily focused on finding common libraries and frameworks rather than solving
CMake's deficiencies.

Awesome CMake
-------------

`Awesome CMake's home <https://github.com/onqtam/awesome-cmake>`_.

Unlike the other items on this list, Awesome CMake is not actually a CMake
project, rather it is a useful resource for CMake. Nevertheless we think it's a
great community resource so we added it to the list.


Build, Link, Triumph (BLT)
--------------------------

`BLT's home <https://github.com/llnl/blt>`_.

BLT provides a series of CMake modules that wrap many of the existing CMake
modules and make them easier to use, with a particular focus on high-performance
computing. BLT's functions primarily consolidate many related CMake calls into
one call (for example, one call for adding sources, headers, and dependencies
to a library/executable). It also:

* supports *ad hoc* toolchain files (really just relabeling CMake's Cache)
* makes setting compiler flags portable
* built-in support for Google Test Framework (GTest) and FORTRAN Unit Test
  Framework (FRUIT)
* support for finding existing libraries (support for common HPC libraries is
  built-in)
* functions for creating your package's documentation

Particularly because of the coupling to specific libraries and compilers, BLT
feels more like a CMake module for a specific group of developers than a general
solution. If your development tastes are similar to those of the BLT developers
BLT is likely to be very useful, if not you are still going to have to write a
lot of additional native CMake for your packages. It is also notable that BLT
has no support for building a dependency.

Cinch
-----

`Cinch's home <https://github.com/laristra/cinch>`_.

The documentation on GitHub is rather lacking, and I was unable to build the
documentation following the instructions on the GitHub site. Point being take
this synopsis with a grain of salt. Cinch appears to consist of a series of
CMake functions for simplifying common tasks like making libraries, versioning
software, *etc.*. The Cinch project appears to work by assuming your package's
source code is setup in a very specific manner and that a command line utility,
``cinch-utils`` can be called from the Cinch CMake modules (has to be built
separately). Cinch's collection of CMake modules suggests that it is primarily
targeted at high-performance computing applications and its inclusion of a few
very specific libraries, like the Cinch Logging Utilities, makes it seem like it
is not intended for general usage.


CMake++
-------

`CMake++'s home <https://github.com/toeb/cmakepp>`_.

This is probably one of the most heavily developed CMake extensions out there.
Unfortunately, it also seems to be zombie-ware as the devel branch has not been
modified since April 2015 and master since July 2017 (which according to the
development model listed on the README is an impossible state...). Anyways,
CMake++ includes a lot of additional features for CMake including:

* better CMake list support
* events (*i.e.*, the visitor pattern)
* a custom ``cmakepp`` interpreter that uses a custom syntax to generate CMake
* functions for manipulating/calling functions dynamically
* logging based on events
* associate arrays
* objects
* dependency management
* process management
* HTTP client

What is particularly astounding is that the above features are implemented
entirely within the CMake language. While there is a lot of overlap between CPP
and CMake++

CPM
---

`CPM"s home <https://github.com/iauns/cpm>`_.

CPM was (it is no longer maintained) CMake module designed to simplify the
retrieval and building of dependencies. This is done by maintaining repositories
of CPM packages, that can be easily retrieved from your package's build system.
While CPM does provide its own repository of CPM packages, conceivably one can
also use additional repositories.

Hunter
------

`Hunter's home <https://github.com/ruslo/hunter>`_.

.. warning::

    This subsection may come off as harsh on the Hunter project, but that's just
    because we have more experience with Hunter than other projects on this
    list.

Hunter  will locate and build dependencies for you automatically. It has a
relatively clean and easy to use API, and works great so long as you only need
packages that Hunter already knows about. That said, Hunter has a number of
shortcomings that ultimately motivated CMakePP:

* Documentation
   Hunter's documentation is lacking particularly when it comes to more advanced
   usage cases.  It's also hard to read.
* No support for virtual dependencies
   In all fairness, as of the time of writing, there were open issues on GitHub
   regarding this.
* Poor support for continuous integration
   Hunter assumed from the start that projects would depend on a particular
   version of a dependency.  With a lot of projects moving to a continuous
   integration model, "releases" are not always available.  Hunter's solution to
   the lack of releases is to use git submodules, but if you've ever tried using
   git submodules you know that they are never the solution...
* Difficult to control
   Hunter is a package manager and thus it assumes that it knows about all of
   the packages on your system. In turn if Hunter didn't build a dependency it
   won't use it (or at least we could not figure out how to override this
   behavior).
* Coupling of Hunter to the build recipes (``hunter/cmake/projects`` directory)
   The build recipes for dependencies are maintained by Hunter.  In order to
   make sure Hunter can build a dependency one needs to modify Hunter's
   source code. While having a centralized place for recipes benefits the
   community, having that place be Hunter's source makes Hunter appear
   unstable, clutters the GitHub issues, and places a lot of responsibility on
   the maintainers of the Hunter repo.
* Only supporting "official" recipes
   Admittedly this is related to the above problem, but Hunter will only use
   recipes that are stored in the centralized Hunter repo.  This makes it hard
   (again git submodules) to rely on private dependencies and hard to use Hunter
   until new dependencies are added to the repo.
* Requires patching repos
   Hunter requires projects to make config files and for those files to work
   correctly.  The problem is what do you do if a repo doesn't do that?
   Hunter's solution is that you should fork the offending repo, and then patch
   it.  While this seems good at first, the problem is you introduce an
   additional coupling.  Let's say the official repo adds a new feature and you
   want to use it.  You're stuck waiting for the fork to patch the new version
   (and like the recipes, forks are maintained by the Hunter organization so
   you can't just use your fork).  The other problem is what happens when a
   user is trying to make your project use their pre-built version of the
   dependency?  Odds are they got that version from the official repo so it
   won't work anyways.

Izzy's eXtension Modules (IXM)
------------------------------

`IXM's home <https://github.com/slurps-mad-rips/ixm>`_.

IXM is a very new project that strives to simply the typical CMake workflow by
providing more robust, easier to use versions of the native CMake commands. IXM
also provides support for remote dependency retrieval. IXM also has some
additional nice features:

* adds a dictionary type
* smarter argument parsing
* prettier printing
* project layouts (auto makes ``CMakeLists.txt`` based on your directories)
* supports fetching dependencies

Perhaps the most questionable "feature" is how IXM goes about doing all this,
namely by overriding CMake's built in commands. IXM also appears to be missing
support for automatically building non-CMake dependencies. Overall IXM appears
to have very similar goals to CMakePP and is a project to watch.

Just A Working Setup (JAWS)
---------------------------

`JAWS's home <https://github.com/DevSolar/jaws>`_.

JAWS is another CMake project that factors one developer's particular
infrastructure into a reusable, version controlled repo. Like similar efforts on
this list, JAWS assumes a very specific software stack and will likely be of
little use to developers with widely different needs.

The Package Manager Manager (PMM)
---------------------------------

`PMM's home <https://github.com/vector-of-bool/pmm>`_.

PMM is an interesting idea. Basically, PMM provides a uniform API for calling
package managers from within your package's CMake build system. At the moment it
only supports Conan and VCPKG. The idea being you use the package managers to
supply your project with its dependencies.
