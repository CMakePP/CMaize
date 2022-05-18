include_guard()
include(cmakepp_lang/cmakepp_lang)

#[[[
# Base class for an entire hierarchy of build and install target classes.
#]]
cpp_class(Target)

    #[[[
    # Creates a ``Target`` object to manage a target of the given name.
    # 
    # .. note::
    #    
    #    This does not create a corresponding CMake target,
    #    so any call that should interact with a target will fail if the
    #    target does not already exist. As a base class with no concrete
    #    analog, ``Target`` really shouldn't be instantiated aside from
    #    testing purposes. Instead, create a child with a concrete target
    #    analog and instantiate that.
    #
    # :param self: Target object constructed.
    # :type self: Target
    # :param tgt_name: Name of the target. This should not duplicate any other
    #                  target name already in scope.
    # :type tgt_name: str
    # :returns: ``self`` will be set to the newly constructed ``Target``
    #           object.
    # :rtype: Target
    #]]
    cpp_constructor(CTOR Target str)
    function("${CTOR}" self tgt_name)

        Target(SET "${self}" _name "${tgt_name}")

    endfunction()

    #[[[
    # Creates a ``Target`` object based on an existing CMake target.
    #
    # :param self: Target object constructed.
    # :type self: Target
    # :param tgt_name: Name of the existing target.
    # :type tgt_name: str
    #
    # :returns: ``self`` will be set to the newly constructed ``Target``
    #           object.
    # :rtype: Target
    #]]
    cpp_constructor(CTOR Target target)
    function("${CTOR}" self tgt_name)

        Target(SET "${self}" _name "${tgt_name}")

    endfunction()

    #[[[
    # Get the CMake target name that the ``Target`` class represents.
    # 
    # :param self: Target object
    # :type self: Target
    # :param return_target: Name of the CMake target.
    # :type return_target: str
    #
    # :returns: Sets ``return_target`` to the name of the CMake target
    #           represented by this class.
    # :rtype: str
    #]]
    cpp_member(target Target str)
    function("${target}" self return_target)

        Target(GET "${self}" "${return_target}" _name)

        cpp_return("${return_target}")

    endfunction()

    #[[[
    # Check if the target has the requested property.
    #
    # .. note::
    #    
    #    The signature is currently ``cpp_member(has_property Target desc str)``
    #    instead of ``cpp_member(has_property Target bool str)`` due to a bug
    #    in CMakePPLang that throws an overload error when a non-boolean is
    #    passed into the ``bool`` parameter. Since this is a return value, we
    #    always pass a non-boolean in and will always trigger the error. By
    #    setting it to ``desc`` type instead, it will accept non-booleans
    #    and the user will have to trust that a boolean string is being
    #    returned from the docs.
    # 
    # :param self: Target object
    # :type self: Target
    # :param has_property: Return variable for if the target has the property.
    # :type has_property: bool
    # :param property_name: Name of the property to check for.
    # :type property_name: str
    #
    # :returns: Sets ``has_property`` according to if the target has the
    #           requested property (True) or not (False).
    # :rtype: bool
    #]]
    cpp_member(has_property Target desc str)
    function("${has_property}" self has_property property_name)

        Target(target "${self}" my_name)

        # Call CMake's built-in `get_target_property()` method.
        get_target_property(property_value "${my_name}" "${property_name}")

        # 'get_target_property()' returns either an empty string or the given
        # return variable name with "-NOTFOUND" appended when the property is
        # not found.
        # 
        # See get_target_property docs for more info:
        # https://cmake.org/cmake/help/latest/command/get_target_property.html#command:get_target_property
        if("${property_value}" STREQUAL "" OR property_value MATCHES "NOTFOUND")
            set("${has_property}" FALSE)
        else()
            set("${has_property}" TRUE)
        endif()

        cpp_return("${has_property}")

    endfunction()

    #[[[
    # Get the requested property for the ``Target``.
    # 
    # :param self: Target object
    # :type self: Target
    # :param property_value: Return variable for the property value.
    # :type property_value: str
    # :param property_name: Name of the property to check for.
    # :type property_name: str
    #
    # :returns: Sets ``property_value`` to the value of the property.
    # :rtype: str
    #
    # :raises PropertyNotFound: Property does not exist in the target.
    #]]
    cpp_member(get_property Target str str)
    function("${get_property}" self property_value property_name)

        Target(has_property "${self}" prop_exists "${property_name}")
        if(NOT prop_exists)
            cpp_raise(PropertyNotFound "Property not found: ${property_name}")
        endif()

        Target(target "${self}" my_name)

        # Call CMake's built-in `get_target_property()` method.
        get_target_property("${property_value}" "${my_name}" "${property_name}")

        cpp_return("${property_value}")

    endfunction()

    #[[[
    # Sets a single property to the given value, creating the property if it
    # does not exist.
    #
    # :param self: Target object
    # :type self: Target
    # :param property_name: Name of the property to set.
    # :type property_name: str
    # :param property_value: Value of the property.
    # :type property_value: desc
    #]]
    cpp_member(set_property Target str desc)
    function("${set_property}" self property_name property_value)

        # Package the property into a map
        cpp_map(CTOR prop_map "${property_name}" "${property_value}")

        Target(set_properties "${self}" "${prop_map}")

    endfunction()

    #[[[
    # Sets the given properties to the given values.
    #
    # .. note::
    #    
    #    Member functions in CMakePPLang cannot be variadic, so it is not
    #    possible to match the API for ``set_target_properties()``. However,
    #    using a ``cpp_map`` is close, so it was used. See the example usage
    #    below for a concise way of using this function.
    #
    # :param self: Target object
    # :type self: Target
    # :param properties: Property names and values.
    # :type properties: cpp_map
    #
    # **Example Usage**
    #
    # .. code-block:: cmake
    #    
    #    # Create a target so the property functions have something to act on
    #    add_custom_target("example_target")
    # 
    #    # Create a Target object
    #    Target(CTOR my_tgt "example_target")
    #
    #    # Assign properties using the cpp_map constructor with the optional
    #    # key-value pairs in the CTOR call
    #    cpp_map(CTOR
    #        property_map
    #        <property_name_1> <property_value_1>
    #        <property_name_2> <property_value_2>
    #        <property_name_3> <property_value_3>
    #        ...
    #    )
    #
    #    # Set the properties on the target with this function
    #    Target(set_properties "${property_map}")
    #]]
    cpp_member(set_properties Target map)
    function("${set_properties}" self properties)

        Target(target "${self}" my_name)

        cpp_map(KEYS "${properties}" keys)

        foreach(key ${keys})
            cpp_map(GET "${properties}" value "${key}")
            set_target_properties("${my_name}" PROPERTIES "${key}" "${value}")
        endforeach()

    endfunction()

    #[[[
    # :type: str
    #
    # Name of the current target.
    #]]
    cpp_attr(Target _name)

cpp_end_class()

