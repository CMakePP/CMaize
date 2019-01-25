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
for that "something": strings or targets. Of those two the latter is a better
option since the former requires a lot of regex. The remainder of this page
details how we map objects to targets.

As a matter of convention for this page, we will use uppercase letters, ``A``,
``B``, ``C``, *etc.*, to denote arbitrary object types. Lowercase letters,
``a``, ``b``, ``c``, *etc.* denote instances of those respective types, *e.g.*
``a`` is an instance of the object type ``A``. If multiple instances of the same
type are needed we will append numbers to the instance names.

Implementation
--------------

CMake targets have a plethora of properties (basically member variables). As
long as we use unique names (*i.e.*, the names do not collide with CMake's
properties) we can add our own properties to the target without consequence.
Thus our strategy is to associate each object instance with a unique target
and to store the object's state in CPP-unique properties. Following other
object-oriented languages, each object type must define a constructor and it
is this constructor that will associate the instance with its CMake target and
specify what members that type has. By convention the constructor for an object
of type ``A`` is the function ``_cpp_A_constructor`` which is used to create
an instance ``a`` like ``_cpp_A_constructor(a ...)``, where the ellipses are
other arguments required for construction. Since CMake does not support function
overloading there can only be one constructor. In practice, the easiest way
around this is to use kwargs and let the ctor worry about defaults.

After construction the value of ``a``, ``${a}``, is set to the name of the
target storing the state. Passing the name of that target to a function makes
that function manipulate the same target that was passed. The result is that CPP
objects behave like a Python objects. This is best expressed with a code
example:

.. code-block:: cmake

   function(fxn_taking_an_object the_instance)
       # set the_instance's member X to 1
   endfunction()

   _cpp_A_constructor(a)
   #set a's member X to 0
   fxn_taking_an_object(${a})
   #a's member X is now 1

   set(a2 ${a}) #is a shallow copy
   #a2's member X is 1
   #set a2's member X to 2
   #a's member X is now 2 (as is a2's member X)


As a slight aside, the target's name is something like ``_cpp_<gibberish>``
where the ``<gibberish>`` part is actually a random string. This design
prevents collisions with any legitimate target (*i.e.*, targets meant for
consumption by CMake) barring malicious intent. It also prevents collisions
with other instances of ``A`` given the same identifier:

.. code-block:: cmake

    function(fxn1)
        _cpp_A_constructor(a)
    endfunction()

    function(fxn2)
        _cpp_A_constructor(a)
    endfunction()

Here the intent is to create two separate instances of type ``A`` (each
constructor makes a new instance), but if we used a name like ``_cpp_a`` for
the target we'd end up colliding the states.

Creating a New Object Type
--------------------------

The previous section detailed how CPP implements objects. This section provides
guidance on creating a new object type. To that end the first step is to
implement your object's constructor. Typically this looks like:

.. code-block:: cmake

    include_guard()
    include(object/object) #Convenience header pulling the Object base class in
    include(utility/set_return) #For prettier returns

    function(_cpp_A_construct _cAc_return ...)
        _cpp_Object_constructor(_cAc_handle)
        _cpp_Object_add_members(${_cAc_handle} member1 member2)
        _cpp_set_return(${_cAc_return} ${_cAc_handle})
    endfunction()

The first line gets a handle to a new object of type ``Object``. For all intents
and purposes you can think of this as an inheritance mechanism which makes your
type inherit from ``Object``. The ``Object`` type defines the minimum API for a
type to work as a class with CPP and all types must ultimately inherit from it.
Note that for a type ``B`` that inherits from a type ``A``, ensuring ``B``
inherits from ``Object`` is trivially satisfied by:

.. code-block:: cmake

   include_guard()
   include(object/object)
   include(utility/set_return)
   include(A/a)

   function(_cpp_B_construct _cBc_return ...)
       _cpp_A_construct(_cBc_handle ${input_to_A_ctor})
       #Finish setting up B class
       _cpp_set_return(${_cBc_return} ${_cBc_handle})
   endfunction()

since ``A`` is responsible for inheriting from ``Object`` as well. The
convention for coding up ``B`` is to make a directory ``a/b`` and in
that directory write a file ``b.cmake`` that includes the constructor
(by convention the file ``ctor.cmake``) as well as each of the scripts
implementing member functions (by convention the member ``_cpp_B_member`` is
implemented in the file ``member.cmake``). Documentation for each member should
be included as part of the member implementations and documentation for the
class as a whole should be part of the constructor's documentation.

Inheritance
-----------

As noted in the last section, CPP objects support single inheritance natively.
If need be, multiple inheritance can be implemented as well, but it is not
supported at the moment. Since CPP objects simply store state, inheritance
simply aggregates the derived class's state with the base class's state, *i.e.*,
the members of the resulting class are the union of the members of the base
class plus those of the type. CPP does not support shadowing of members
(assuming ``B`` derives from ``A`` and ``A`` has a member ``member``, ``B`` must
use ``A``'s member ``member`` and not define its own). Since there really aren't
member functions (*vide infra*) CPP does not support virtual functions.


Member Functions
----------------

Implementing member functions requires a callback mechanism. The only way to
implement callbacks in CMake is to write out a CMake script on-the-fly and run
it with CMake's ``execute_process`` command. This makes callbacks relatively
expensive because one has to write and read a file to disk (although modern
operating systems likely will also cache the file making this much faster) and
execute a subprocess. For this reason member functions are implemented C-style,
*i.e.*, as free functions. By convention the member function ``member`` of the
``A`` type is mangled to ``_cpp_A_member`` and must take an ``A`` instance
before any other arguments, including returns. When implementing ``member`` you
are responsible for declaring it in this manner, *e.g.*, an implementation may
look something like:

.. code-block:: cmake

    include_guard()

    function(_cpp_A_member _cAc_handle _cAc_return ...)
        #Do stuff to the provided instance
        _cpp_set_return(${_cAc_return} ${a_value}
    endfunction()

Following this convention makes it possible to implement member functions at a
later time by storing a class's full type hierarchy and current type in
``Object``'s metadata and then defining a function like
``_cpp_call_member(member_name HANDLE handle RETURNS ... ARGS ...)``.
