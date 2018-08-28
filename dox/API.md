CPP API
=======

This page describes the main aspects of the CPP API.

Minimum Working Example (MWE)
-----------------------------

The MWE root `CMakeLists.txt` for CPP is:

```
cmake_minimum_required(VERSION X.X)
project(<your_projects_name> VERSION X.X.X)
find_package(CMakePackagingPro CONFIG REQUIRED)
CPP_find_package(NAME <name> REQUIRED)
CPP_add_library(
    NAME <name> 
    SOURCES <source_files>
    DEPENDS <list_of_dependencies>             
)
CPP_install(TARGETS <names...>)
```

Line 1 and 2 are the common starts to any CMake project.  Line 3 finds CPP and
ensures its functions are available for use.  Line 4 asks CPP to find a 
dependency Line 5 declares the library using
CPP's convenience macro and line  


Public API
----------

### find_package

Attempts to find a package with the requested specifications.  Any fields that
are not set are considered flexible (*i.e.* )

Syntax:

```
cpp_find_package(
    <package>
    [OPTIONAL]
    [VERSION <version>]
    [CMAKE_ARGS <arg1> [<arg2> ...]]
)    
```

Arguments:
- `package` the name of the package to locate.
- `OPTIONAL` if specified failure to find the package will not raise an error
- `nameX` used to request that a virtual package be satisfied by one of the 
  named implementations.  Names earlier in the list have higher precedence. 
  If `package` is non-virtual this will be ignored.
- `VERSION`       


Global variables used:
- `BUILD_SHARED_LIBS` if true will ensure dependencies are built with `-fPIC`

### find_virt_package

Attempts to find a virtual package with the requested specifications.  With the
exception of the `IMPLS` field works identical to `cpp_find_package`

Syntax:

```
cpp_find_virt_package(
    <package>
    [OPTIONAL]
    [IMPLS <name1> [<name2>...]]
    [VERSION <version>]
    [CMAKE_ARGS <arg1> [<arg2> ...]]
    
```

Arguments:
- `nameX` used to request that only the named implementations be used.  Names 
  earlier in the list have higher precedence.   

Developer Functions
-------------------

These are functions primarily meant for use within CPP source code.  To 
distinguish them from functions that are part of the public API they are 
prefixed with an underscore.  For brevity the documentation in this section 
leaves off the common `_cpp_` prefix of function names.

### is_defined

A function for determining whether or not a variable is defined.  Note that 
in CMake a defined variable may be empty.

Syntax:

```
_cpp_is_defined(<return> <var>)
```

Arguments:
- `return` the variable that will contain the result of the check.  Will be set
  to 1 if `var` is defined and 0 otherwise.
- `var` the variable name to check


### is_empty

A function that determines whether or not a variable is set to a value.  Note
that in CMake an undefined variable will appear as empty.

Syntax:

```
_cpp_is_empty(<return> <var>)
```

Arguments:
- `return` the variable that will contain the result of the check.  Will be set
  to 1 if `var` is empty and 0 otherwise
- `var` the variable to check for a value  

### debug_print

A function for printing a message, but only if `CPP_DEBUG_PRINT` is set to 
true.

Syntax:

```
_cpp_debug_print(<msg>)
``` 

Arguments:
- `msg` the message to print if in debug mode
