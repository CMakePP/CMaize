include_guard()

## This function asserts that there are no unparsed kwargs
#
# This function is nothing more than a call to :ref:`cpp_is_empty-label` coupled
# to an error message. Nonetheless, given how often we don't want to support
# unparsed kwargs this function prevents quite a bit of code duplication.
#
# :param unparsed: The list of unparsed kwargs.
function(_cpp_kwargs_handle_unparsed _ckhu_unparsed)
    _cpp_is_empty(_ckhu_is_empty _ckhu_unparsed)
    if(_ckhu_is_empty)
        return()
    endif()
    _cpp_error("Found unparsed kwargs: ${_ckhu_unparsed}.")
endfunction()
