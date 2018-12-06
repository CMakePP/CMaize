.. _motivations-label:

Motivations
===========

This page details why we wrote CPP.  In particular we explain the overall
problem and why the other solutions didn't meet our needs.  If you don't care
why we wrote CPP the way we did we recommend jumping to the next page
:ref:`assumptions-label`.

After using CMake for a while an overall pattern becomes apparent:

1. Find suitable dependencies
2. Build missing dependencies
3. Build project.
4. Test project.
5. Package project.

Strictly speaking one could argue that step 2 shouldn't be done by the build
system (it's really the job of a package manager); however, there's a bazillion
possible dependencies out there and expecting every possible package manager to
know about every possible package is unrealistic.  Furthermore asking the user
to build your project's dependencies decreases the user-friendliness (and thus
the adoption) of your project.  This is why we have chosen to include it.

Anyways, of the above list, steps 1 and 2 are the hardest. This is because
CMake's ``find_package`` and ``ExternalProject_Add`` commands are designed to be
quite general. If the dependency you are trying to use was packaged using CMake,
then these two functions will work without too much hassle; unfortunately, a
vanishingly small number of actual projects do this. The result is your
project's build system is typically tightly coupled to the manner in which your
dependencies were packaged. Such coupling is problematic when it occurs in
source code, and unsurprisingly, leads to similar problems in the build system.

This leads to CPP, namely, we need a set of CMake extensions that facilitates
incorporating non-ideal dependencies into a project.

Additional Considerations
-------------------------

While not the primary motivation for writing CPP these were additional
considerations that were part of its design.

* Written in CMake
   CMake isn't the prettiest or easiest language to use, but it's the *de facto*
   standard for generating C/C++ build systems.  We choose to write CPP in CMake
   in order to avoid introducing additional dependencies into the project and to
   ensure that CPP integrates well with existing package managers.
* Capable of supporting virtual dependencies
   Virtual dependencies, dependencies focused more on an API than a particular
   library (*e.g.*, BLAS and MPI), need to be supported both at the API level as
   well as at the implementation level *e.g.*, need to be able specify that your
   project depends on BLAS or it depends on MKL (Intel's implementation of
   BLAS).
* Support for continuous integration workflows
   A lot of projects are moving to some version of continuous integration where
   concepts such as commit hashes and branches have more meaning than a numeric
   version (or perhaps better put, there's a gazillion versions, one for each
   tweak).
* Project builder has final say in which implementation of a package is used
   Particularly on systems used for software development or for
   high-performance computing, the user may want to use a particular version of
   a dependency thus there needs to be a mechanism to ensure the dependency
   manager uses that version.
* Caching of dependencies
   During development it is common to "blow-away" the build directory to, for
   example, ensure one is not using stale assets.  99.9% of the time when one
   is doing this, they do not want the dependencies to be blown away.
* Decentralized management of build/find recipes
   Recipes for finding and building dependencies should not be restricted to a
   single location.  This allows each project to provide its own set of recipes,
   as well as allowing various communities and organizations to maintain their
   own set of recipes.  It also turns maintaining the recipes into a community
   endeavor instead of coupling it to CPP's development/maintenance.
* Use find modules for non-conforming packages
   If you're going to try to find a dependency that doesn't use config files or
   uses them wrong, you should use a find module.  While far inferior to config
   files, they're the only solution that will work without changing the
   non-conforming package's source code.


Other Relevant Projects
-----------------------


In order to put CPP in perspective this section describes some other relevant
projects.

Hunter
^^^^^^

Hunter main page is available `here <https://github.com/ruslo/hunter>`_. As a
disclaimer, this subsection may come off as harsh on the Hunter project, but
that's just because we initially tried Hunter before deciding to write CPP.
Hence, we have more experience with Hunter than other projects on this list.

Like CPP, Hunter is written entirely in CMake and will locate and build
dependencies for you automatically.  Admittedly, Hunter was great at first
and seemed to fit our needs, but then a number of problems began to manifest
(and in no small part influenced the above additional considerations section):

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
   won't use it (or at least I could not figure out how to override this
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

Build, Link, Triumph (BLT)
^^^^^^^^^^^^^^^^^^^^^^^^^^

BLT's home is `here <https://github.com/llnl/blt>`_. Just came across this
repo so I don't know much about it yet, but at first glance appears to do much
of what CPP does.

Autocmake
^^^^^^^^^

Autocmake's home is `here <https://github.com/dev-cafe/autocmake>`_.

Cinch
^^^^^

Cinch's home is `here <https://github.com/laristra/cinch>`_.
