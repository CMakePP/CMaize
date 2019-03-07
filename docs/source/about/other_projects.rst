Other Relevant Projects
=======================

In order to put CPP in perspective this section describes some other relevant
projects. Projects are considered relevant if they strive to simplify the
writing of the CMake infrastructure. The maintainers of CPP do not actively keep
tabs on other CMake projects so this information may become out of date. Instead
consider this page a snapshot of the field at the time writing of CPP started.

Autocmake
---------

`Autocmake's home <https://github.com/dev-cafe/autocmake>`_.

Build, Link, Triumph (BLT)
--------------------------

`BLT's home <https://github.com/llnl/blt>`_.

* Focus is on simplifying writing cross-platform CMake scripts
* Wrappers around common CMake functions like ``add_library``.
* No support for building external dependencies.

Cinch
-----

`Cinch's home <https://github.com/laristra/cinch>`_.

CMake++
-------

`CMake++'s home <https://github.com/toeb/cmakepp>`_.

Hunter
------

`Hunter's home <https://github.com/ruslo/hunter>`_.

.. warning::

    This subsection may come off as harsh on the Hunter project, but that's just
    because we have more experience with Hunter than other projects on this
    list.

Hunter is written entirely in CMake and will locate and build dependencies for
you automatically. It has a relatively clean and easy to use API, and works
great so long as you only needs packages that Hunter already knows about. That
said, Hunter has a number of shortcomings that ultimately motivated CPP:

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

Just A Working Setup (JAWS)
---------------------------

`JAWS's home <https://github.com/DevSolar/jaws>`_.
