.. _cpp_parse_target-label:

cpp_parse_target
################

.. function:: _cpp_parse_target(<project> <component> <target>)

    Separates a scoped target
    
    Modern CMake recommends using targets of the form ``project::component``. This
    function will parse the name of a target and split it on the ``::``. If there
    is no ``::`` the component return will be empty.
    
    :param project: An identifer who's value will be set to
    