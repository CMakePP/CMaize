Motivations
===========

When we started CPP our goal was to develop a C++ dependency manager that 
integrated seamlessly into a typical CMake/C++ workflow.  Such a workflow for a 
project `MyProject` is characterized by:

1. Locate or build `MyProject`'s external dependencies
  - These are dependencies that `MyProject`'s build will not build
  - Also includes dependencies `MyProject` can build, but for some reason the 
    user does not want `MyProject` to build
2. Run `cmake` on `MyProject` supplying paths to external dependencies
  - `MyProject` may build some dependencies at this point
3. Run `make`
  - Additional dependencies may be built
  - `MyProject` is built
  - Tests for `MyProject` are built at this point
4. (Optional) run tests
5. Run `make install`           
  
This workflow assumes that there is no development on the source code.  If there
is development, steps 3 through 5 would be rerun after modifications are made. 
It is also common for `MyProject` to be a dependency of another project, say
`OtherProject`.  In this case `OtherProject` may want to use a particular 
version of `MyProject` or it may want to always follow a particular version 
control tag, say "master".

In order to facilitate user-adoption it is common to have `MyProject`'s build
system take care of as many dependencies as possible.  Although CMake provides
numerous tools for aiding in this endeavor such as: `ExternalProject_Add` and
`find_package`.  Finding an arbitrary package and ensuring compatibility 
remains difficult. Admittedly this is not really a task for CMake, but for a 
dependency manager.

In our opinion the ideal dependency manager:
- Introduces minimal additional dependencies
  - Ideally in CMake given it's now *de facto* role as a C++ build system
- Is capable of automatically building dependencies
- Supports virtual dependencies
  - Dependencies like BLAS and MPI that are technically just interfaces with
    multiple implementations      
- Correctly "versions" binaries, not just by the literal version/commit, but
  by compiler, build options, compiler flags, and dependencies
- Allows the user to exactly specify which instance of a dependency to use
  - Package developers may set dependencies up conservatively, for performance
    may need to override
- Leads to reproducible builds on all platforms
- Supports multiple binary/source file caches

### Elephant In the Room: Hunter

Admittedly the description above sounds similar to the Hunter project.  That 
said, in our opinion Hunter is insufficient because:

- Lack of support for arbitrary package repositories
  - Hunter only supports a centralized recipe repo
  - Too much burden on Hunter maintainers
- Packages have to be hunter-ized upstream
  - Likely that users/other package managers will use official repos
  - Downstream modifications allow official repos to be used     
- Works off of releases
  - CI workflows are now typical and may want to just follow "master"  
  - Developing two packages, each of which is in a CI workflow, is hard
    - With Hunter need to keep releasing or use git submodules 
- Difficult to follow documentation  

Don't get us wrong, Hunter is a great product, it just doesn't satisfy our 
needs. 

### What's Up With the Name?

Basically I originally wanted to call the project CMake++, but that name was 
taken by an already existing project (that appears to be abandon).  I then 
decided I'd settle for backronyming the name so that the abbreviation was CPP.  
Using CMake for the "C" was a given and all that remained was to decide on two
"P" words that somewhat related to the project.  "Packaging" and "Project" 
seemed good enough and the name was born...
