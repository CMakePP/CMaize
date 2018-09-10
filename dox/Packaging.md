Packaging
=========

This page summarizes the state of packaging a C++ project with CPP as well as
using packages.

Ideal
-----

In a perfect world every project that uses CMake would package their project
correctly.  As best as I can tell "correctly" means (assuming an install root
 `prefix` and a package name `package`):

1. Moving/copying the `prefix` directory does not break the installation
   - *i.e.* the install should be relocatable
2. There should exist a file `<package>-config.cmake`
   - May also be named `<package>Config.cmake`
   - Lowercase variant preferred for case-insensitive operating systems
   - On Unix-like OS's typically installed in `<prefix>/share/cmake/<name>` or
     `<install_root>/lib/cmake/<name>`
     - `name` is typically `package`, but for virtual dependencies will be the 
       names of the implementations
     - CPP relies on `find_package` to locate this file so any of the paths
       typically searched by `find_package` are fine  
   - Usually created with `configure_package_config_file`
3. `<package>-config-version.cmake` file exists next to `<package>-config.cmake`
   - Can also be named `<package>ConfigVersion.cmake`
   - Auto created by calling `write_basic_package_version_file`
4. The config file should create an imported target `<package>::<comp>` for 
   each component of the package
   - Targets file can be created by passing `EXPORT <file name>` to 
     `install(TARGETS ...)`
   - Should populate `INTERFACE_` variants of: `COMPILE_DEFINITIONS`, 
     `COMPILE_FEATURES`, `INCLUDE_DIRECTORIES`, and `LINK_LIBRARIES`
   - Should set `IMPORTED_LOCATION_X` for each configuration `X`    
5. `<package>-config.cmake` should ensure all dependencies can be found and that
   targets referenced in `INTERFACE_LINK_LIBRARIES` exist

The specifications above are a bit more detailed than they probably need to be
as the mentioned CMake routines will take care of much of the set-up; however,
CPP handles non-ideal packages by setting the targets up manually and thus it
is useful to outline what set-up that entails. 

   
Real World
----------

A growing number of packages follow the ideal set-up; however, there are still a
large number that don't (including those that use `autotools`).  Ideally those
packages would be open to accepting contributions that patch their build systems
so that they are compatible with the ideal CMake packaging, but inevitably some
projects will not be open to such efforts (if they are, then once they're 
patched they fall into the ideal category and we don't need to worry about 
them).  

So how do we handle non-ideal dependencies?  One solution is by maintaining a
fork (*i.e.* a mirror) of the dependency that has been patched so that the fork 
makes the dependency ideal.  While this at first appears to be a good solution 
it runs into problems when one realizes that package managers and other users of
that dependency are very unlikely to use your mirror; in other words, they're
going to be using the official repo and will be incompatible with the fork.  
Thus the resulting packages will not be usable with CPP and the user/package
manager will need to additionally maintain the forked version.  In practice this 
amounts to a lot of work on the user's side and is undesirable.  Another 
solution is to use `FindXXX.cmake` files.  While the use of such files is 
frowned upon, they do have the advantage of decoupling the steps required to 
idealize the dependency from that dependency's install. Thus assuming the 
package is an official installation, the `FindXXX.cmake` file serves as a 
recipe for turning the install into a usable dependency.  Such files are also
easier to maintain than forks/mirrors, typically requiring no additional 
modifications unless the package undergoes a major rewrite.



Finding Dependencies
--------------------

This is where things get tricky.  Conceivably a user/developer may want to be 
able to specify with arbitrary precision many details pertaining to a dependency
including: compile features, version, and components.  Furthermore, these 
details may need to be specified recursively for each sub-dependency.  Managing
all of this information is a job for a package manager.  CPP is not a package
manager and therefore does not attempt to do this.  Instead CPP ensures that a 
particular instance of a dependency is used throughout the build.  This instance
can be specified by the user or it can be built by CPP.  

Find Dependency Procedure
-------------------------

### Non-virtual dependency

For this section we assume the user is attempting to locate a dependency named
`Depend` (case-sensitive).  Although we used camel case for our dependency names 
we stress that all lowercase is the preferred convention.

Ultimately we want the user to have full control so the first thing we do is
look for a variable `Depend_ROOT`.  If the variable is set:

1. We look for a Config file under the `Depend_ROOT` directory
   - `find_package` is used so the config file can be in any of the usual places
2. If the config file is not found we let the `FindDepend.cmake` file try to 
   find it.  Writers for `FindDepend.cmake` are responsible for honoring 
   `Depend_ROOT`.
3. If `FindDepend.cmake` can't find it an error is returned.

If the user did not specify `Depend_ROOT` we follow a similar trajectory.

1. We attempt to find a config file honoring `CMAKE_PREFIX_PATH`
2. If no config file is found we let `FindDepend.cmake` try
3. If we still can't find it, we build it.
   - Build recipes must be in a file `BuildDepend.cmake` or `build-depend.cmake`
   - `CPP_BUILD_RECIPES` can be set to a list of folders containing build
      recipes
   - Dependencies built this way will be installed into the directory given by
     `CPP_LOCAL_CACHE`
          
               
