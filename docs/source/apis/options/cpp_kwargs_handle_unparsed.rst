.. _cpp_kwargs_handle_unparsed-label:

cpp_kwargs_handle_unparsed
##########################

.. function:: _cpp_kwargs_handle_unparsed(<unparsed>)

    This function asserts that there are no unparsed kwargs
    
    This function is nothing more than a call to :ref:`cpp_is_empty-label` coupled
    to an error message. Nonetheless, given how often we don't want to support
    unparsed kwargs this function prevents quite a bit of code duplication.
    
    :param unparsed: The list of unparsed kwargs.
    