CMakePackagingProject
=====================

[![Documentation Status](https://readthedocs.org/projects/cmakepackagingproject/badge/?version=latest)](https://cmakepackagingproject.readthedocs.io/en/latest/?badge=latest)

Welcome to the CMakePackagingProject (CPP) repository.

CMake represents a powerful scripting language for automating your project's
build system.  Unfortunately, using CMake to write a reliable, reproducible, and
reusable build system is a non-trivial task.  CPP aims to dramatically simplify
this task by making use of an internal dependency manager.  With CPP managing
dependencies writing a build system for a project can be as easy as filling in
the following boilerplate:

```.cmake
cmake_minimum_required(VERSION <cmake_version>)
project(<project_name> VERSION <project_version>)
find_package(cpp REQUIRED)

foreach(depend <list_of_dependencies>)
    cpp_find_dependency(${depend})
endforeach()    

cpp_add_executable(
    <program_name>
    SOURCES <list_of_source_files>
    DEPENDS <list_of_dependencies>
)
cpp_install(TARGETS <program_name>)    
```

For more details consult [the documentation](https://cmakepackagingproject.readthedocs.io/en/latest/?badge=latest).
