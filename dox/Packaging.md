Packaging
=========

This page describes the process by which CPP locates dependencies.  Given that
this process needs to be capable of occurring recursively, packages created
using CPP will adhere to the "ideal" standards outlined below.

Ideal
-----

In a perfect world every project that uses CMake would package their project
correctly.  As best as I can tell "correctly" means (assuming an install root
 `prefix` and a package name `package`):

1. Moving/copying the `prefix` directory does not break the installation
   - *i.e.* the install should be relocatable
2. There should exist a file `<package>-config.cmake`
   - May also be named `<package>Config.cmake`
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

This is where things get tricky.  Even the ideal CMake packages do not keep
track of enough information for us to be able to infer every detail of their
build.  From an ideal build we can gather the following:

- version
- build type (release, debug, *etc.*)
- components
- compile-time definitions specified by `target_compile_definitions`
- compiler flags specified by `target_compile_options`
- locations of dependencies (and thereby via recursion the above information)

That's about it.  Generally speaking it is possible to back out a few additional
properties using  

If we want to screen a dependency for anything else we need to
keep track of it ourselves.  Making matters worse, for non-ideal dependencies we
may not even be able to discern the above information.  This leaves us in a 
situation where 


Assume that the current CMake project depends on `my_depend`, which in turn 
depends on `my_depend2`.  In the current CMake project the user writes:

```
cpp_find_dependency(my_depend REQUIRED)    
```

(assuming it is a required dependency, otherwise the)

Given an ideal dependency `my_depend` (CPP convention is all dependencies are 
specified using snake_case) CPP will look for the variable `my_depend_PREFIX`, 
which if set, is assumed to point to the root of the install tree for 
`my_depend`.  `find_package` will then be used to find the config file for us 
throwing an error if it is not found (it is assumed that if a user sets that
variable they expect it to be used)
and the appropriate targets will be created. If 
`my_depend_PREFIX` is not specified, `find_package` is still called, but now it
will search places specified in `CMAKE_PREFIX_PATH` as well as in typical 
system locations (*e.g.*, `/usr/lib`, `/usr/local/lib` on Unix-like systems).

