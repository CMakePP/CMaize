.. _cpp_parse_arguments-label:

cpp_parse_arguments
###################

.. function:: cpp_parse_arguments(<_prefix> <_argn>)

    
    This function wraps the CMake function ``cmake_parse_arguments`` and makes it
    more user-friendly. The biggest addition is more error checking. This
    includes erroring if:
    
    - one of our kwargs appears more than once.
    - the user provided us with an unrecognized kwargs
    
        - We can only catch this if the user provided the unrecognized kwarg
          before all other kwargs. If they did not it'll get mixed in with the
          lists.
    
    - one of the user's kwargs appears more than once.
    - if a required kwarg is not set
    
    Our wrapper function also guarantees that toggles that are not set are set to
    false and that it is possible to set an option/list to an empty string. The
    latter enables forwarding of arguments like:
    
    .. code-block:: cmake
    
        cpp_parse_arguments(_prefix "${ARGN}" OPTIONS OPTION1)
        a_fxn(OPTION1 "${_prefix_OPTION1}")
    
    without having to worry about whether or not ``_prefix_OPTION1`` was set.
    
    .. note::
    
        We do **NOT** error if there are unpased arguments in the list of
        arguments we are parsing on behalf of the user. It is recommended that the
        user call :ref:`cpp_kwargs_handle_unparsed-label` if their function does
        not rely on the unparsed arguments in some manner.
    
    :param prefix: The namespace to use for scoping the returns (*e.g.*, setting
        prefix="_cpa" will result in identifiers like ``_cpa_NAME``).
    :param argn: The list of additional arguments to your function. This should
        be provided like ``"${ARGN}``.
    
    :kwargs:
    
        * *TOGGLES* (``list``) - Denotes a list of kwargs that should be parsed as
          toggles.
        * *OPTIONS* (``list``) - Denotes a list of kwargs that should be parsed as
          options.
        * *LISTS* (``list``) - Denotes a list of kwargs that should be parsed as
          lists.
        * *MUST_SET* (``list``) - Denotes a list of kwargs that must contain a
          value.
    