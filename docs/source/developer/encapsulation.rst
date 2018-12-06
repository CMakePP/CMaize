Encapsulation
=============

CMake is a functional programming language, which is great for simple procedural
things, but is not so great for modeling more complicated concepts. Our present
strategy for making the modeling of more advanced concepts easier is to
introduce "objects" we do this C-style.  Basically, we define free functions
that take an instance of the object and t
