Conventions
===========

Functions
---------

- The use of the `macro` command should be avoided in almost all scenarios
- Functions part of the public API should be namespace protected by prepending 
  `cpp` to them
- Functions meant only for use within CPP should additionally be prependend 
  with a "_" character, *i.e.*, the full prefix is `_cpp`    
- All function input names should be prefaced with `_` and the initials of the
  function (*e.g.*, the return value of `cpp_is_defined` is `_cid_return`)
  - Note: When nesting functions input variables with the same name clobber
    each other.  This is designed to avoid that.
- Variables defined within the function should follow the same convention as
  input variables  
    

If Statements
-------------
Somewhat ironically, I find if statements to be one of the hardest parts of the
CMake language.  The following conventions are designed to avoid as many gotchas
as possible.

- When checking if the contents of a variable `my_var` is true do not 
  dereference it, *i.e.*, `if(my_var)` not `if(${my_var})`
  - `CMake` will automatically try to dereference it for you
  - Depending on the value of `my_var` the second syntax can lead to issues
- Avoid the `NOT` keyword
  - The `NOT` syntax is touchy and error-prone owing to the implicit conversions
    between strings and booleans      

Modules
-------
