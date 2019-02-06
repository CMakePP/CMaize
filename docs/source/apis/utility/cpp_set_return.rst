.. _cpp_set_return-label:

cpp_set_return
##############

.. function:: _cpp_set_return(<identifier> <value>)

    Macro that wraps returning a value from a function
    
    While the syntax to return a value from a function in CMake is not superhard
    (it's just ``set(return_identifier return_value PARENT_SCOPE)``) it's easy to
    forget the ``PARENT_SCOPE`` (plus the fact that it's all caps makes it
    slightly annoying to type repeatedly) which leads to subtle errors. The syntax
    is also not super descriptive of what is going on. This macro wraps the CMake
    ``set`` function call in a more descriptive call that doesn't require you to
    remember the ``PARENT_SCOPE``.
    
    :param identifier: The identifier we are setting the value of.
    :param value: The value to set the identifier to.
    