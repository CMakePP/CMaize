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
