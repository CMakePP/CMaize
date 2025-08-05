# Copyright 2023 CMakePP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

include_guard()
include(cmakepp_lang/cmakepp_lang)

#[[[
# Base class for an entire hierarchy of build and install target classes.
#]]
cpp_class(CMaizeTarget)

    #[[[
    # :type: path
    #
    # Directory where the target binary will be installed.
    #]]
    cpp_attr(CMaizeTarget install_path)

    #[[[
    # Creates a ``CMaizeTarget`` object to manage a target of the given name.
    # 
    # .. note::
    #    
    #    This does not create a corresponding CMake target,
    #    so any call that should interact with a target will fail if the
    #    target does not already exist. As a base class with no concrete
    #    analog, ``CMaizeTarget`` really shouldn't be instantiated aside from
    #    testing purposes. Instead, create a child with a concrete target
    #    analog and instantiate that.
    #
    # :param self: CMaizeTarget object constructed.
    # :type self: CMaizeTarget
    # :param tgt_name: Name of the target. This should not duplicate any other
    #                  target name already in scope.
    # :type tgt_name: desc or target
    #
    # :returns: ``self`` will be set to the newly constructed ``CMaizeTarget``
    #           object.
    # :rtype: CMaizeTarget
    #]]
    cpp_constructor(CTOR CMaizeTarget str)
    function("${CTOR}" self _ctor_name)

        CMaizeTarget(SET "${self}" _name "${_ctor_name}")

    endfunction()

    #[[[
    # Get the CMake target name that the ``CMaizeTarget`` class represents.
    # 
    # :param self: CMaizeTarget object
    # :type self: CMaizeTarget
    # :param return_target: Name of the CMake target.
    # :type return_target: desc*
    #
    # :returns: Sets ``return_target`` to the name of the CMake target
    #           represented by this class.
    # :rtype: desc
    #]]
    cpp_member(target CMaizeTarget desc)
    function("${target}" self return_target)

        CMaizeTarget(GET "${self}" "${return_target}" _name)

        cpp_return("${return_target}")

    endfunction()

    #[[[
    # Check if the target has the requested property.
    # 
    # :param self: CMaizeTarget object
    # :type self: CMaizeTarget
    # :param has_property: Return variable for if the target has the property.
    # :type has_property: bool*
    # :param property_name: Name of the property to check for.
    # :type property_name: desc
    #
    # :returns: Sets ``has_property`` according to if the target has the
    #           requested property (True) or not (False).
    # :rtype: bool*
    #]]
    cpp_member(has_property CMaizeTarget desc desc)
    function("${has_property}" self has_property property_name)

        CMaizeTarget(target "${self}" my_name)

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
    # Get the requested property for the ``CMaizeTarget``.
    # 
    # :param self: CMaizeTarget object
    # :type self: CMaizeTarget
    # :param property_value: Return variable for the property value.
    # :type property_value: str*
    # :param property_name: Name of the property to check for.
    # :type property_name: desc
    #
    # :returns: Sets ``property_value`` to the value of the property.
    # :rtype: str
    #
    # :raises PropertyNotFound: Property does not exist in the target.
    #]]
    cpp_member(get_property CMaizeTarget desc desc)
    function("${get_property}" self property_value property_name)

        CMaizeTarget(has_property "${self}" prop_exists "${property_name}")
        if(NOT prop_exists)
            cpp_raise(PropertyNotFound "Property not found: ${property_name}")
        endif()

        CMaizeTarget(target "${self}" my_name)

        # Call CMake's built-in `get_target_property()` method.
        get_target_property("${property_value}" "${my_name}" "${property_name}")

        cpp_return("${property_value}")

    endfunction()

    #[[[
    # Sets a single property to the given value, creating the property if it
    # does not exist.
    #
    # :param self: CMaizeTarget object
    # :type self: CMaizeTarget
    # :param _sp_property_name: Name of the property to set.
    # :type _sp_property_name: desc
    # :param args: Values of the property. This uses all additional
    #              arguments provided to the function as the value
    #              for the property.
    #              TODO: Verify how to document this parameter properly
    # :type args: args
    #]]
    cpp_member(set_property CMaizeTarget desc args)
    function("${set_property}" self _sp_property_name)

        # Package the property into a map
        cpp_map(CTOR _sp_prop_map)

        # TODO: This may hang or throw if no property value is given (ARGN)
        cpp_map(SET "${_sp_prop_map}" "${_sp_property_name}" "${ARGN}")

        CMaizeTarget(set_properties "${self}" "${_sp_prop_map}")

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
    # :param self: CMaizeTarget object
    # :type self: CMaizeTarget
    # :param _sp_properties: Property names and values.
    # :type _sp_properties: cpp_map
    #
    # **Example Usage**
    #
    # .. code-block:: cmake
    #    
    #    # Create a target so the property functions have something to act on
    #    add_custom_target("example_target")
    # 
    #    # Create a CMaizeTarget object
    #    CMaizeTarget(CTOR my_tgt "example_target")
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
    #    CMaizeTarget(set_properties "${property_map}")
    #]]
    cpp_member(set_properties CMaizeTarget map)
    function("${set_properties}" self _sp_properties)

        CMaizeTarget(target "${self}" _sp_tgt_name)

        cpp_map(KEYS "${_sp_properties}" _sp_keys)

        foreach(_sp_key ${_sp_keys})
            cpp_map(GET "${_sp_properties}" _sp_value "${_sp_key}")
            set_target_properties(
                "${_sp_tgt_name}"
                PROPERTIES
                    "${_sp_key}" "${_sp_value}"
            )
        endforeach()

    endfunction()

    #[[[
    # :type: str
    #
    # Name of the current target.
    #]]
    cpp_attr(CMaizeTarget _name)

cpp_end_class()

