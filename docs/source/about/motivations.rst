.. _motivations-label:

Motivations
===========

This page motivates the need for a package like CPP. The `other_projects-label`_
page discusses the alternatives to CPP and why we still felt that devleoping CPP
was justified.

Why CMake?
----------

Since CPP extends CMake, it makes sense to start with a motivation for why one
should even consider using CMake with their package. For that matter, why even
use a build system? After all the final compilation just looks something like:

.. image:: manually_compile.*

While it's true that the actual compilation amounts to nothing more than calling
the compiler on a mound of source files, archiving sets of the resulting objects
into libraries, and then linking the results together, what the above image
fails to capture is the complicated web of dependencies among those source files
as well as the myriad of compiler/linker options that are available for each of
these calls. This is what most build systems bring to the table, a way to easily
track dependencies among the various pieces of your project.

.. sidebar:: On-The-Fly Build System

    .. image:: OnTheFly.png

The problem with most build systems is that they were designed with a rather
static picture of the software stack in mind. Modern development practices have
led to packages with fluid builds. It is now common place for a build  to
support multiple configurations, optional dependencies, and (shudder) multiple
architectures. While it is possible to bend existing build systems to your will,
it is far easier to generate the build system on-the-fly. The result is what are
sometimes called "meta-build systems". For all practical purposes one can treat
the fact that meta-build systems generate build systems as an implementation
detail and simply think of meta-build systems as "modern" build systems.

CMake falls into the category of modern/meta-build systems. Users of CMake
describe their package's configure, build, test, and install settings in the
CMake language. The CMake language is designed to make common build concepts,
like executables, libraries, and dependencies first-class citizens. Thanks to a
syntax resembling shell-scripting more than a traditional build system, CMake
greatly simplifies writing dynamic build systems for a package. Compared to its
largest competitor, GNU's Autotools, CMake's nicer syntax and cross-platform
nature (as a disclaimer it is fully possible to write cross-platform Autotools
build systems, it's just a lot harder than doing it in CMake) has caused CMake
to become the *de facto* build system for C/C++ projects.

Why CPP?
--------

The last section makes CMake sound like the greatest thing since sliced bread,
so why do we need CPP? In our opinion CMake represents the best of the available
build options; however, CMake is still a bad option. By this we mean that CMake
is loads better than trying to write one's own build system, or attempting to
use a more traditional build system in place of CMake; however, CMake still
fails to **natively** support several key build-system features:

* Automated and reliable building of dependencies
* Support for "virtual" dependencies (satisfied by many libraries ; think BLAS)
* Reliable dependency detection
* Automated packaging
* Dependency cacheing

In all fairness it is possible to do everything on the above list using CMake
(if it were not, then CPP wouldn't be possible). The problem is that the
mechanisms and patterns for doing so are boilerplate heavy, poorly documented,
and fragile. Adding to the frustration is the fact that the CMake language
feels quite antiquated compared to scripting languages like Python. Notably the
CMake language lacks (native) support for:

* Objects
* Callbacks
* Lambdas
* Overloading
* Associative arrays
* Lists (that aren't super buggy because they're strings delimited by ``;``)
* Serialization
* Intraspection

It is our opinion, that we have reached another point in software development
warranting another layer on the build-system stack. It is perhaps time to stop
bandaging the build-system stack and start over; however, inertia is the biggest
opponent here. Many existing packages have developed relatively robust and
reliable build systems based on CMake and/or Autotools and they are reluctant to
adopt new build systems. Unfortunately, new build systems are also unlikely to
be taken up by newer packages, since there is a propensity for these packages to
ensure that they are consumable in a manner akin to more established packages.
Thus we are in a situation where change is need, but it is unlikely.

This brings us to CPP. Most of the actual source code of CPP implements a series
of extensions to the CMake language causing it to be more friendly to modern
developers. Notably this means introducing objects. Using modern object-oriented
paradigms CPP then implements the features missing from CMake in a way that
makes the features seem native. The result is that by using CPP you will invest
minimal effort in your build system, while still appearing to the outside world
as if your package maintainers have spent eons fine-tuning a traditional CMake
build system.


Design Points/Features
----------------------

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



Keep in mind that the software stack just described evolved somewhat organically
over the last several decades. If the software stack had been written today it
is likely that it would be very different.
