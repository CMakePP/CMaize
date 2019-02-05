.. _kwargs-label:

Keyword Arguments in CPP
========================

Keyword arguments, or kwargs for short, are a mechanism for supplying arguments
to a function that relies on associating each argument with a keyword instead
of a position. This is particularly helpful for when a function has many
arguments and not all of them are required. CMake natively has support for
kwargs; however, this support is extremely fragile. CPP introduces the
``Kwargs`` class to rectify this while still supporting kwargs.

CMake's Native Kwarg Support
----------------------------

CMake has a concept of kwargs and this concept is a staple of newer CMake
functions. For example, consider CMake's ``find_package`` function. One possible
call to this function may look something like:

.. code-block:: cmake

    find_package(
        ${depend}
        REQUIRED
        PATHS ${path1} ${path2} ${path3}
    )

Here the first argument is a positional argument telling ``find_package`` the
name of the dependency it is looking for. ``REQUIRED`` and ``PATHS`` are
keywords. CMake supports three kinds of keywords flags, options, and lists. Flag
keywords are booleans, if they appear the corresponding kwarg is set to true
and if they do not appear the kwarg is false (in the ``find_package`` example
``REQUIRED`` is an example of a flag). Options are kwargs that expect one
user-supplied argument (unfortunately ``find_package``'s list of recognized
kwargs doesn't include any options; they look like ``PATHS`` if ``PATHS``
only took one argument). Lists are kwargs that expect one or more user-supplied
arguments (here ``PATHS`` is an example of a list kwarg).

By default all CMake functions are variadic (they accept an arbitrary number of
arguments). All arguments past the the positional arguments get lumped into a
list called ``ARGN`` (not to be confused with ``ARGC`` which is the number of
arguments provided to the function or ``ARGV`` which is all of the arguments
provided to the function). Semantically, CMake processes a function call by
first putting all provided arguments into the ``ARGV`` list, which for the
above ``find_package`` call looks like:

.. code-block::

    ARGV = ${depend};REQUIRED;PATHS;${path1};${path2};${path3}

CMake then removes the first ``n`` arguments, where ``n`` is the number of
positional arguments in the function's declaration. The remaining arguments
comprise the ``ARGN`` list. Control then proceeds into the function.

Unlike languages like Python, which have built-in kwarg support, CMake's kwarg
support is implemented by calling the CMake function ``cmake_parse_arguments``
and providing it ``ARGN``. This leads to the first gotcha, if the user
accidentally skips a positional argument (for example if in the above
``find_package`` call ``${depend}`` evaluated to empty) then the first
``ARGN`` is promoted to that spot. For this reason it is best to not mix
native kwargs and positional arguments. For each type of kwarg,
``cmake_parse_arguments`` requires a list of keywords. This is CMake's solution
to the lack of nested lists. More concretely, consider the value of ``ARGN``:

.. code-block::

    ARGN = REQUIRED;PATHS;${path1};${path2};${path3}

There's a bunch of different ways to interpret this list, including:

* 5 flags: ``REQUIRED``, ``PATHS``, ``${path1}``, ``${path2}``, ``${path3}``
* 1 list: ``REQUIRED``, with contents ``PATHS;${path1};${path2};${path3}``
* 2 options: ``REQUIRED`` and ``${path1}`` with values ``PATHS`` and ``{path2}``
  respectively as well as 1 flag: ``${path3}``

By providing a list of keywords, as well as how many arguments should follow it
(zero, one, one or more) CMake now knows how to parse the list.

This seems like an acceptable solution to kwargs until one tries developing with
functions requiring kwargs. Let's say one is making a function
``find_or_build_package`` which first calls ``find_package`` and then calls
``ExternalProject_Add`` if the package isn't found. Ideally, the caller of
``find_or_build_package`` should be able to specify accepted kwargs for either
of the two subfunctions and ``find_or_build_package`` will forward them. For
example something like:

.. code-block:: cmake

    find_or_build_package(
        ${depend}
        REQUIRED
        PATHS ${path1} ${path2} ${path3}
        SOURCE_DIR ${path2src}
    )

seems reasonable as a call to ``find_or_build_package`` that would map to
something like:

.. code-block:: cmake

    find_package(${depend} ${ARGN})
    if(NOT_FOUND)
        ExternalProject_Add(
            ${depend}
            ${ARGN}
        )
    endif()

One expects this to work as long as both functions ignore keywords they do not
understand. The reality is it will not work because ``cmake_parse_arguments`` is
not capable of ignoring keywords that it doesn't recognize. Consider what the
call to ``cmake_parse_arguments`` looks like inside ``find_package``:

.. code-block:: cmake

    ARGN = REQUIRED;PATHS;${path1};${path2};${path3};SOURCE_DIR;${path2src}

Since ``cmake_parse_arguments`` does not recognize the ``SOURCE_DIR`` keyword it
and its value, ``${path2src}``, are assumed to be elements of the ``PATHS``
list. The only way to avoid this is to know all keywords at parsing time. This
is a royal pain as it introduces a lot of coupling.

CPP Kwarg Support
-----------------

CPP's treatment of kwargs is handled by the ``Kwargs`` class. This class works
like a map and stores the values of each keyword individually so that there is
no ambiguity in parsing. That said, in order to get a kwarg syntax some
function, somewhere needs to support CMake's native kwargs. Ideally we want to
do this in a way that we can minimize coupling. Our solution is that every
function that uses kwargs needs to define a function ``_cpp_xxx_add_kwargs``,
where the ``xxx`` is the name of the function. This function is responsible for
adding to a ``Kwargs`` instance all keywords needed by the ``xxx`` function as
well as all functions ``xxx`` will call.

For example consider a simple function ``our_fxn`` that accepts a flag (CPP
uses "toggle" to avoid confusion with compiler flags) called ``A_FLAG``, an
option ``AN_OPTION``, and a list ``A_LIST``. We'll assume that this function
does not pass the kwargs to any subfunctions. The relevant code is:

.. code-block:: cmake

    function(_cpp_our_fxn_add_kwargs _cofak_kwargs)
        _cpp_Kwargs_add_keywords(
            ${_cofak_kwargs}
            TOGGLES A_FLAG
            OPTIONS AN_OPTION
            LISTS A_LIST
        )
    endfunction()

    function(_cpp_our_fxn _cof_kwargs)
        _cpp_our_fxn_add_kwargs(${_cof_kwargs})
        _cpp_Kwargs_parse_argn(${_cof_kwargs} "${ARGN}")
        #Do stuff with kwargs
    endfunction()

    _cpp_Kwargs_ctor(kwargs)
    _cpp_our_fxn(${kwargs} A_FLAG AN_OPTION ${value} A_LIST ${value1} ${value2})


The first eight lines define a function that encapsulates adding the keywords to
the ``Kwargs`` object.  If we wanted to set defaults for the kwargs, or mark a
kwarg as required, this is where we'd do it. The next five lines are the
implementation of our function. The first line of our function piggybacks off
of the ``add_kwargs`` function to setup the ``Kwargs`` instance before
parsing ``ARGN`` on the next line. With this pattern it is always possible to
call our function with CMake native kwargs (*i.e.*, like the last line) or to
pass a ``Kwargs`` instance to our function.

If our function called a function ``fxn_2`` that also used kwargs we'd need to
modify ``_cpp_our_fxn_add_kwargs`` as follows:

.. code-block:: cmake

    function(_cpp_our_fxn_add_kwargs _cofak_kwargs)
        _cpp_fxn_2_add_kwargs(${_cofak_kwargs})
        _cpp_Kwargs_add_keywords(
            ${_cofak_kwargs}
            TOGGLES A_FLAG
            OPTIONS AN_OPTION
            LISTS A_LIST
        )
    endfunction()

Our actual function remains the same. Note that with this single adjustment the
``Kwargs`` instance now knows about all keywords needed by ``fxn_2`` (and its
subfunctions) without us having to explicitly list them. The only coupling we
pick up is to the name of the subfunction. Furthermore, this coupling is
encapsulated to functions that call ``our_fxn``.
