Packaging
=========

Ideal
-----

In a perfect world every project that uses CMake would package their project
correctly.  As best as I can tell "correctly" means:

1. Installs a `<name>-config.cmake` file (`<name>` is lowercase)
   - Ideally created with `configure_package_config_file`
   - Responsible for importing targets (*vide infra*)
   - Responsible for   
2. Installs a `<name>-version.cmake` file containing version information
   - Auto created by calling `write_basic_package_version_file`
3. Creates an imported target `<name>::<comp>` for each component of the package
   - Auto created by passing `EXPORT <file name>` to `install(TARGETS ...)`

CPP    
   
Real World
----------

A growing number of packages follow the ideal set-up; however, there are still a
large number that don't (including those that use `autotools`).  Ideally those
packages would be open to accepting contributions that patch their build systems
so that they are compatible with the ideal CMake packaging, but inevitably many
projects will not be open to such efforts (if they are then once they're 
patched they fall into the ideal category and we don't ) 
Unfortunately
package managers will rely on wrapping the official repos
