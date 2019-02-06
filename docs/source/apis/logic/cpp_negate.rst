.. _cpp_negate-label:

cpp_negate
##########

.. function:: _cpp_negate(<result> <input>)

    Negates the input variable
    
    CMakes logic constructs are hard to use correctly, including the ``NOT``
    construct. This function encapsulates the logic for negating a boolean,
    *i.e.*, turning true into false and false into true. It works for any value
    that CMake establishes as having a truth-ness to it.
    
    :param result: An identifier to hold the negated result
    :param input: A boolean to negate
    