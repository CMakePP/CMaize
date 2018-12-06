.. _dependencies-label:

Registering Your Project's Dependencies with CPP
================================================

This page describes how to add dependencies to your project. CPP strives to
make this process as painless as possible. That said, the harsh reality is
that a lot of packages out there have some quirk associated with their build
process and/or finding the package. There's no way that CPP can possibly be
aware of all of these quirks, so you may need to expend a bit more effort for
packages that have a number of quirks.

By means of convention we use ``<Name>`` as a place-holder for the name of the
dependency, in its native case, ``<name>`` for the name of the dependency in all
lowercase, and ``<NAME>`` for the all uppercase variant of the name.

Overview
--------

There are two commands to add a dependency to your project
``cpp_find_dependency`` and ``cpp_find_or_build_dependency``.  As you might
guess, the former will only look for the dependency whereas the latter will
build the dependency if it can't find it. Regardless of which command you use
there's always at least one required parameter ``NAME``, which is the (case-
sensitive) name of the dependency. This makes the bare-bones command for
locating a dependency:

.. code-block:: cmake

   cpp_find_dependency(NAME <Name>)

This assumes a number of things, importantly that your dependency installs
config files. If you additionally want CPP to build the dependency for your user
then we minimally also require a way to obtain the source, *e.g.*, if the source
is located on the internet:

.. code-block:: cmake

   cpp_find_or_build_dependency(NAME <name> URL <url>)

Note, that some websites have standardized URLs for retrieving a particular
version of a dependency. If CPP knows your website's standard (currently limited
to GitHub), then you often can get by with a more generic (shorter) URL. See the
:ref:`downloading_the_source-label` section for more details.

For projects with well written CMake build systems, that's typically all that
one needs to add a dependency. Depending on how much the dependency deviates
from this depends on how much additional information is required. The following
list should give you an idea how much work is needed to add a particular
dependency to CPP. The rest of this section provides more information pertaining
to providing CPP with said information.

1. Always need the name of the dependency.
2. If bad (or no) config files: need a find module.
3. If building need a way to obtain source

   a. ``URL`` if it should be downloaded.
   b. ``SOURCE_DIR`` if on local filesystem

4. If configuration is non standard (not CMake or autotools) need a build module
5. If non-standard configuration need to set ``CMAKE_ARGS``.
6. If dependency does not properly handle its subdependencies you need to
   repeat these steps, recursively, for each subdependency.


Getting the Source
------------------

CPP can automatically obtain and use source code that is either available
locally (such as included with your project or on your filesystem if you want to
work offline) or it can be downloaded.

Using Local Source
^^^^^^^^^^^^^^^^^^

Assuming you have the source for a dependency located at the path ``/a/path``,
it can be provided to CPP like:

.. code-block:: cmake

   cpp_find_or_build_dependency(NAME <Name> SOURCE_DIR /a/path)


.. _downloading_the_source-label:

Downloading Source
^^^^^^^^^^^^^^^^^^

A typical ``cpp_find_or_build_dependency`` command that downloads the source
code looks like:

.. code-block:: cmake

   cpp_find_or_build_dependency(NAME <Name> URL <url>)

By default CPP will assume that the URL is a direct download link, *i.e.*, that
by following the link a download will start. This is undesirable because it
makes switching between versions of a dependency more difficult. Thankfully most
of the common hosting websites have standardized APIs for downloading
assets that CPP can exploit. These are outlined in the following subsections.
When using these APIs CPP will default to always using the latest version.

Adding Dependencies Hosted on GitHub
""""""""""""""""""""""""""""""""""""

GitHub is one of the most popular sites to host open source software on.  You
may or may not know that it also provides a rich URL-based API for selecting the
branch and/or version as well as forwarding credentials.  CPP is aware of this
API.  Thus to get the most out of a GitHub based repo it is recommended that you
provide the URL as ``github.com/organization/repo`` and not point to a specific
branch, tag, commit, tarball, or release. Specific branches can be requested
using the ``BRANCH`` keyword, *e.g.*

.. code-block:: cmake

   cpp_find_or_build_dependency(
      NAME <Name>
      URL github.com/organization/repo
      BRANCH a_branch
   )

and a specific commit, tag, or release by the ``VERSION`` keyword, *e.g.*,

.. code-block:: cmake

   cpp_find_or_build_dependency(
      NAME <Name>
      URL github.com/organization/repo
      VERSION 1.2.3
   )


Configuring a Module
--------------------

By default CPP will analyze the dependency's source code in an attempt to
configure it. Specifically it will look for ``CMakeLists.txt`` to signal that
CMake should be used or ``configure.ac`` to signal autotools. If the dependency
does not use either of these build system generators, or if it uses them in a
non-standard way, then you'll need to write a build module.

Configuring a CMake Dependency
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This is the easiest scenario. Thanks to the somewhat viral nature of CMake, if
your dependency also uses CMake we can just directly configure the dependency
with the same options your project uses. If you for whatever reason what to use
different/additional options while configuring the dependency you can pass them
to ``cpp_find_or_build_dependency`` like:

.. code-block:: cmake

    cpp_find_or_build_dependency(
        NAME <Name>
        CMAKE_ARGS Option1=Value1
                   Option2=Value2
    )

The additional arguments will automatically be forwarded to the dependency (and
accounted for when attempting to locate the dependency).

Configuring an Autotools Dependency
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

For the most part there's a one-to-one mapping between CMake and Autotools so
CPP can automatically convert the values of variables like
``CMAKE_CXX_COMPILER`` to the Autotools equivalent ``CXX``. CPP will also take
care of specifying common compiler flags (like ``-fPIC``) based on the values
of the CMake environment. The only slightly tricky part is letting CPP know
about the non-standard options (*e.g.*, signal that a component should not be
built). CPP reuses the ``CMAKE_ARGS`` keyword to
``cpp_find_or_build_dependency`` for this purpose. For example,

.. code-block:: cmake

    cpp_find_or_build_dependency(
        NAME <Name>
        CMAKE_ARGS Option1=Value1
                   Option2=Value2
    )

Would result in a call to ``configure`` like:

.. code-block:: bash

    ./configure --Option1=Value1 --Option2=Value2 ...

That is CPP will prepend ``--`` to them and pass them as flags to configure.

At the moment CPP can automatically convert the following to autotools:

1. C and C++ compilers
2. Position independent code
3. ``CMAKE_INSTALL_PREFIX``, *i.e.*, where to install it

Writing a Build-Module
^^^^^^^^^^^^^^^^^^^^^^

If your dependency does not use any of the meta-build systems, or if it uses
them in a non-standard way you will have to write a build-module. The contents
of the build-module will be dumped verbatim into the build-recipe and thus it
should honor the input variables provided by the build-recipe API. The easiest
way to implement the build-module is to piggyback off of CMake's
``ExternalProject_Add`` command. Thus an example build-module could look
something like:

.. code-block:: cmake

    include(ExternalProject)
    #Do some set-up like calculating dependency paths or option values

    ExternalProject_Add(
        <Name>_External #Suffix to avoid target collisions
        SOURCE_DIR ${_cbr_src} #Path to source, provided by build-recipe
        CONFIGURE_COMMAND ...
        BUILD_COMMAND ...
        INSTALL_DIR ${_cbr_install} #Where to install, provided by build-recipe
        INSTALL_COMMAND ...
    )



Writing a Find-Module
---------------------

If your dependency does not install CMake config files you will need to write a
find-module. Unfortunately, there is no way around this as what constitutes
finding a dependency depends on the definition of that dependency.

I'm too lazy to write this section right now.

Nested Dependencies
-------------------

In an ideal world your dependency will take care of locating and building its
own dependencies. Of course, we don't live in an ideal world so there are going
to be dependencies for which you need to
