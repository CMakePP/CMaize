.. _encapsulation-label:

Encapsulation and Objects in CMake
==================================

CMake is a functional programming language, which is great for simple procedural
things, but is not so great for modeling more complicated concepts and of course
we need to model more complicated things... Our present strategy for
circumventing this limitation is to introduce "objects"; we do this in a manner
very akin to C structs.  Basically, what we do is define a series of free
functions that take an "instance" (quotes explained in a second) of the object
as well as any arguments required by the function. CMake does not support the
creation of struct/classes, which means we have to somehow map the object's
state onto something CMake does support. CMake provides two reasonable choices
for that "something": strings or targets. Of those two the latter is a bit
easier as the former requires implementing a parser in CMake (basically you'd
store the state in JSON or XML and then the parser would extract the relevant
information). The remainder of this page details how we map objects to targets.

As a matter of convention for this page, we will use uppercase letters, ``A``,
``B``, ``C``, *etc.*, to denote arbitrary object types. Lowercase letters,
``a``, ``b``, ``c``, *etc.* denote instances of those respective types, *e.g.*
``a`` is an instance of the object type ``A``. If multiple instances of the same
type are needed we will append numbers to the instance names.

Implementation
--------------

CMake targets have a plethora of properties (basically member variables). We can
add our own properties to the target without consequence, so long as the names
of the properties do not conflict with property names defined by CMake. Thus
our strategy is to associate each object instance with a unique target and to
store the object's state in CPP-unique properties. Each CPP-defined object type
must define a constructor and it is this constructor that will associate the
instance with its target and specify what members that type has. By convention
the constructor for an object of type ``A`` is the function ``_cpp_A_construct``
which is used to create an instance ``a`` like ``_cpp_A_construct(a)``. The
resulting instance behave like Python objects. This is best expressed with a
code example:

.. code-block::cmake

   function(fxn_taking_an_object the_instance)
       # set the_instance's member X to 1
   endfunction()

   _cpp_A_construct(a)
   #set a's member X to 0
   fxn_taking_an_object(${a})
   #a's member X is now 1

   set(a2 ${a}) #is a shallow copy
   #a2's member X is 1
   #set a2's member X to 2
   #a's member X is now 2 (as is a2's member X)


In terms of the above code example ``${a}`` can be thought of as the "value of
the instance ``a`` points to". In reality ``${a}`` is actually the name of the
target that holds ``a``'s state. The target's name is something like
``_cpp_<gibberish>_A`` where the ``<gibberish>`` part is actually a random
string. This design hopefully prevents collisions with any legitimate target
(*i.e.*, targets meant for consumption by CMake) created by a dependency. It
also should prevent collisions with other instances of ``A`` given the same
identifier:

.. code-block::

    function(fxn1)
        _cpp_A_construct(a)
    endfunction()

    function(fxn2)
        _cpp_A_construct(a)
    endfunction()

Here the intent is to create two separate instances of type ``A`` (each
constructor makes a new instance), but if we used a name like ``_cpp_a_A`` for
the target we'd end up colliding the states.

The actual target that gets created is an interface library to avoid having
to associate dummy source code with the library. All properties CPP adds to the
target are prefixed with ``_cpp``. For introspectiion purposes CPP stores some
metadata on the target. This metadata includes:

- ``_cpp_Object_member_list``: A list of all members

When we add a member ``xxx`` to the object it creates the property ``_cpp_xxx``.
Since these properties are set on a per target basis the member ``xxx`` can be
interpreted differently on another target of another type without consequence.

One caveat with this design is that there is no deletion. Even when all
variables containing the handle to an object instance go out of scope the actual
target will still exist. As far as I know there is no way to delete a target
from CMake. This design supports 62^5 instances of each object type, *i.e*
roughly a billion, so the lack of memory is likely to be a problem before
the lack of an untaken identifier.



Creating a New Object Type
--------------------------

The previous section detailed how CPP implements objects. This section provides
guidance on creating a new object type. To that end the first step is to
implement your object's constructor. Typically this looks like:

.. code-block::cmake
    include_guard()
    include(object/new_target)

    function(_cpp_A_construct instance)
        _cpp_Object_new_target(_cAc_handle A)
        _cpp_Object_add_member_value(_cAc_handle member1 member2)
        set(${instance} ${_cAc_handle} PARENT_SCOPE)
    endfunction()

The first line obtains a fresh
