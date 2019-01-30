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
of type ``A`` is the function ``_cpp_A_ctor`` which is used to create
an instance ``a`` like ``_cpp_A_ctor(a ...)``, where the ellipses are
other arguments required for construction. Since CMake does not support function
overloading there can only be one constructor.

After construction the value of ``a``, ``${a}``, is set to the name of the
target storing the state. You can think of the target's name as a handle and
thus passing the name of that target to a function causes that function to
manipulate read the same instance that was passed. The result is that CPP
objects behave like a Python objects. This is best expressed with a code
example:

.. code-block:: cmake

   function(fxn_taking_an_object the_instance)
       # set the_instance's member X to 1
   endfunction()

   _cpp_A_ctor(a)
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
        _cpp_A_ctor(a)
    endfunction()

    function(fxn2)
        _cpp_A_ctor(a)
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

    function(_cpp_A_ctor _cAc_return ...)
        _cpp_Object_ctor(_cAc_handle)
        _cpp_Object_add_members(${_cAc_handle} member1 member2)
        _cpp_Object_set_type(${_cAc_handle} A)
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
   include(a/a)

   function(_cpp_B_ctor _cBc_return ...)
       _cpp_A_ctor(_cBc_handle ${input_to_A_ctor})
       #Finish setting up B class
       _cpp_set_return(${_cBc_return} ${_cBc_handle})
   endfunction()

since ``A`` is responsible for inheriting from ``Object`` as well.

Inheritance
-----------

As noted in the last section, CPP objects support single inheritance natively.
Since CPP objects simply store state, inheritance simply aggregates the derived
class's state with the base class's state, *i.e.*, the members of the resulting
class are the union of the members of the base class plus those of the type.
CPP does not support shadowing of members (assuming ``B`` derives from ``A`` and
``A`` has a member ``member``, ``B`` must use ``A``'s member ``member`` and not
define its own). Since there really aren't member functions (*vide infra*) CPP
does not support virtual functions.


Member Functions
----------------

Implementing member functions requires a callback mechanism. The usual way to
implement callbacks in CMake is to write out a CMake script on-the-fly and run
it with CMake's ``execute_process`` command. This makes callbacks relatively
expensive because one has to write and read a file to disk (although modern
operating systems likely will also cache the file making this much faster) and
execute a subprocess. Another way to do callbacks that only requires reading a
file is to use duck typing. This relies on CMake's ``include`` command.
Basically needs a function that looks like:

.. code-block:: cmake

    include(${path_to_file})
    _call_fxn_brought_into_scope_by_file(${ARGN})

This works because CMake allows the path to the include file to be read from a
variable. However, it requires us to know the name of the function ahead of time
or else we have to do a callback of the first kind. A function ``call_member``
has been started using this method, but has not been finished (it resides in
``object/call_member.cmake``).

Regardless, at the moment, member functions are implemented C-style, *i.e.*, as
free functions. "Virtual" functions can then be implemented by dispatching in
the base class's member function like:

.. code-block:: cmake

    function(_cpp_A_member_fxn _cAmf_handle ...)
        #Assume B and C are classes derived from A
        _cpp_Object_has_base(${_cAmf_handle} _cAmf_is_B B)
        _cpp_Object_has_base(${_cAmf_handle} _cAmf_is_C C)
        if(_cAmf_is_B) #dispatch to B's member
            _cpp_B_member_fxn(${_cAmf_handle} ...)
        elseif(_cAmf_is_C) #dispatch to C's member
            _cpp_C_member_fxn(${_cAmf_handle} ...)
        else()
            # Base class implementation
        endif()
    endfunction()

Admittedly this is a lot of boiler plate.

.. warning::

    Like C++ you should avoid using "virtual" member functions in a constructor.
    In theory, each class will see it's version of the member function (or that
    of the most recent base to override it); however, this behavior is not
    guaranteed or tested for at this time.

Conventions
-----------

* The implementation for a class ``A`` should reside in a directory ``a``
* If ``B`` inherits from ``A``, ``B``'s implemenation should reside in ``a/b``
* The constructor of the ``A`` class should reside in a file ``a/ctor.cmake``
* For a class ``A``, a member function ``member_fxn``, should be implemented in
  a function ``_cpp_A_member_fxn``, which should be defined in a file
  ``a/member_fxn.cmake``
* The first argument to a member function is always a handle
