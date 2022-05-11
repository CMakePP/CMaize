include_guard()
include(cmakepp_lang/cmakepp_lang)

#[[[
# Base class for an entire hierarchy of build and install classes. Basic API
# is found `here <https://raw.githubusercontent.com/CMakePP/CMaize/master/
# docs/src/developer/overall_design.png>`__.
# 
# Modern CMake is target-based, meaning for CMaize to be able to interact
# with CMake effectively CMaize will need to be able to generate CMake
# targets. The ``Target`` class provides an object-oriented API for interacting
# with a CMake target. It also serves as code factorization for
# functionality/APIs common to all target types. Native CMake only has one
# type of target, which can be annoying since the target is interacted with
# in different ways depending on what it describes. The classes which derive
# from Target provide a more user-friendly means of interacting with specific
# target types than native CMake does.
#]]
cpp_class(Target)

    #[[[
    # Default constructor for Target object.
    #
    # :param self: Target object constructed.
    # :type self: Target
    # :returns: ``self`` will be set to the newly constructed ``Target``
    #           object.
    # :rtype: Target
    #]]
    cpp_constructor(CTOR Target)
    function("${CTOR}" self)

        # Initialize the Target object
        Target(__initialize "${self}")

    endfunction()

    #[[[
    # Get the CMake target string that the ``Target`` class represents.
    # 
    # :param self: Target object
    # :type self: Target
    # :param return_target: CMake target return variable.
    # :type return_target: str
    #
    # :returns: Sets ``return_target`` to the CMake target represented by
    #           this class.
    # :rtype: str
    #
    # :raises NotImplemented: This member function needs to be implemented by
    #                         a child class.
    #]]
    cpp_member(target Target str)
    function("${target}" self return_target)

        cpp_raise(NotImplemented "Target.target() needs to be implemented!")

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

        Target(GET "${self}" my_properties _properties)
        cpp_map(HAS_KEY "${my_properties}" "${has_property}" "${property_name}")

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

        Target(GET "${self}" prop_map _properties)
        cpp_map(GET "${prop_map}" "${property_value}" "${property_name}")

        cpp_return("${property_value}")

    endfunction()

    #[[[
    # :type: cpp_map
    #
    # Properties of the CMake target.
    #]]
    cpp_attr(Target _properties)

    #[[[
    # :type: str
    #
    # Generated CMake target. To ensure you get the most up-to-date version
    # use the ``Target(target`` method to get the CMake target.
    #]]
    cpp_attr(Target _target)

    #[[[
    # Initialize the internals of the object.
    #
    # :param self: Target object to initialize.
    # :type self: Target
    #]]
    cpp_member(__initialize Target)
    function("${__initialize}" self)

        # Create an empty property map
        cpp_map(CTOR tmp_map)
        Target(SET "${self}" _properties "${tmp_map}")

    endfunction()

cpp_end_class()

