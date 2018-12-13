.. _cpp_kwargs_unique-label:

cpp_kwargs_unique
#################

.. function:: _cpp_kwargs_unique(<kwargs> <argn>)

    
    When working with kwargs, it is ambiguous if a kwarg appears more than once.
    For example assume we are looking for the kwarg "OPTION" and the user has
    provided the input "OPTION X OPTION Y". What should the value of OPTION be set
    to X or Y? Another situation, is when we are using functions that take
    callbacks. Here if the callback takes the same kwargs as our function there is
    no way to tell which kwarg belongs to your function and which kwarg belongs to
    the callback. This function will loop over the kwargs to your function and
    determine if any of them appear multiple times in the arguments the user
    provided. If any kwarg appears multiple times an error will be raised.
    
    :param kwargs: The list of kwargs to search for.
    :param argn: The arguments to search for the kwargs in.
    