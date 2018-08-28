Conventions
===========

Variable names
--------------

Functions
---------

- The use of the `macro` command should be avoided in almost all scenarios
- All function names should be namespace protected by prepending `cpp` to them
- All function  input names should be prefaced with `_` and the initials of the
  function (*e.g.*, the return value of `cpp_is_defined` is `_cid_return`)
  - Note: When nesting functions input variables with the same name clobber
    each other.  This is designed to avoid that.
- Variables defined within the function should follow the same convention    
