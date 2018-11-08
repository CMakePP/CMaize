CMakePackagingProject
=====================

[![Documentation Status](https://readthedocs.org/projects/cmakepackagingproject/badge/?version=latest)](https://cmakepackagingproject.readthedocs.io/en/latest/?badge=latest)

Welcome to the CMakePackagingProject (CPP) repository.

CMake is a meta build system, in that it is a tool for generating cross-platform 
build systems. To do this, CMake provides a powerful scripting language which 
must be flexible enough to describe the build and packaging requirements of any 
project. Unfortunately, this flexibility comes at the price of complexity. While
it is easy to use CMake to build and package a project on a single platform, it 
is non-trivial to ensure that the resulting package can be reliably and 
reproducibly built and consumed on arbitrary platforms. Generally speaking, with 
full knowledge of a project's dependencies, generating reliable and reusable 
packages comes down to following established CMake best practices. 

At its core, CPP is a dependency manager, written entirely within the CMake 
scripting language. By leveraging its internal dependency manager, CPP makes 
following CMake best practices as simple as filling in the following 
boilerplate:

```.cmake
cmake_minimum_required(VERSION <cmake_version>)
project(<project_name> VERSION <project_version>)
find_package(cpp REQUIRED)

cpp_find_dependency(NAME <depend1>)
cpp_find_dependency(NAME <depend2>)    

cpp_add_executable(
    <program_name>
    SOURCES <list_of_source_files>
    DEPENDS <list_of_dependencies>
)
cpp_install(TARGETS <program_name>)    
```

The above example assumes that the user has all dependencies already built.  The
real power of CPP comes from the fact that, when a suitable version of a 
dependency is not found, CPP can automatically build and manage that dependency. 
As an example assume that our above project uses the popular C++ unit testing
framework, [Catch2](https://github.com/catchorg/Catch2).  The above example 
becomes:

```.cmake
cmake_minimum_required(VERSION <cmake_version>)
project(<project_name> VERSION <project_version>)
find_package(cpp REQUIRED)

cpp_find_or_build_dependency(NAME Catch2 URL https://github.com/catchorg/Catch2)

cpp_add_executable(
    <program_name>
    SOURCES <list_of_source_files>
    DEPENDS Catch2::Catch2
)
cpp_install(TARGETS <program_name>)    
```

For more details consult [the documentation](https://cmakepackagingproject.readthedocs.io/en/latest/?badge=latest).
