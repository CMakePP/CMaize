.. _quick_start-label:

Quick Start
===========

Projects using CPP are encouraged to use this page as their build documentation,
so if you're seeing this page odds are the package you're trying to build uses
CPP for their build.  If you are a complete CMake newbie (there's nothing wrong
with that, we all were at some point) check out the :ref:`cmake_primer-label`
page to get acclimated.

Step 1: Get CPP
-----------------

Assuming you have CMake the first step is to get CPP.  CPP's official download
site is from the GitHub repo located
`here <https://github.com/CMakePackagingProject/CMakePackagingProject>`_.  CPP
is configured, built, and installed like any other CPP package.  Meaning the
following should suffice to obtain, configure, build, and install CPP:

.. code-block:: bash

   git clone https://github.com/CMakePackagingProject/CMakePackagingProject
   cd CMakePackagingProject
   cmake -H. -B<build_dir> -D<Option1>=<value> ...
   cmake --build <build_dir>
   cmake --build <build_dir> --target install

Obviously you will need to replace ``<build_dir>`` with the name of a directory
to be used as the build directory and ``<Option1>`` and ``<value>`` with the
option and value you want to set. Note that you only need to install CPP once.
So if you've previously completed Step 1 skip to Step 2.

Step 2: Build the Project
-------------------------

We'll assume that the source code for the package you are trying to build is
located in the directory ``package_dir``.  Configuring, building, and installing
is done analogous to how it was done for CPP:

.. code-block:: bash

   cd package_dir
   cmake -H. -B<build_dir> -D<Option1>=<value> ...
   cmake --build <build_dir>
   cmake --build <build_dir> --target install

There are a lot of possible options for configuring both CPP and the package,
thus we strongly suggest you check out :ref:`standard_cmake-label` for a list
of the more important considerations. If you are setting more than
``CMAKE_PREFIX_PATH`` and/or ``CMAKE_INSTALL_PREFIX`` it is strongly recommended
that you use a toolchain file to ensure that all of your options get forwarded
to each dependency (generally speaking, `-D` options are only seen by the
top-level `cmake` project). More details on using a toolchain file can be found
at :ref:`toolchains-label`.

Troubleshooting
---------------

While we've striven to make CPP as foolproof as possible, the reality is bugs do
occur and sometimes you build can get locked in a stale state.  Thus if a build
fails we recommend you consider the following tips:

* Ensure you have provided CMake with all options required by the package

  * Consult the package's documentation for a list of all such options

* Try deleting your build directory and rebuilding

  * CMake does a great job of determining when it needs to regenerate or modify
    a file, but it gets stuck some times.

* Make sure CPP is up to date

  * Particularly at the moment, CPP is experiencing rapid development and a bug
    fix may have been added for your problem.

If your problem still persists check out our page :ref:`faq_build-label` to see
if this a common problem.  Finally, if you still can not resolve the problem
consider opening an issue on CPP's GitHub repo (please look to see if an issue
already exists before opening a new one).
