include_guard()
include(cmakepp_lang/cmakepp_lang)

list(APPEND _CMAIZE_Toolchain_autopopulated_variable_names "CMAKE_C_COMPILER")
list(APPEND _CMAIZE_Toolchain_autopopulated_variable_names "CMAKE_CXX_COMPILER")

#[[[
# The Toolchain class is a source code representation of the toolchain file
# that can be provided by users to specify options sent to every dependency.
# 
# Users need a way to specify options which should be passed to every 
# dependency. By convention this is done by setting the options in a 
# toolchain file. The Toolchain class is the source code representation of 
# this file and provides CMaize a way to interact with the toolchain file 
# the user provided. Two sets of values will be in the Toolchain instance: 
# those set by the user in the actual file, and those CMaize autopopulates 
# (autopopulated variables will be things like the compiler which we 
# explicitly pass to ensure consistent builds).
#]]
cpp_class(Toolchain)

    ## Path to the toolchain file this class represents
    cpp_attr(Toolchain file_path)

    ## Map of options set by the user, these take higher priority than those 
    ## automatically populated. This should be treated as immutable once 
    ## the values are read into it.
    cpp_attr(Toolchain toolchain_options)
    
    ## Map of options automatically populated and where any further key 
    ## changes will be stored.
    cpp_attr(Toolchain auto_options)

    #[[[
    # Default constructor for Toolchain object with only autopopulated
    # options available.
    #]]
    cpp_constructor(CTOR Toolchain)
    function("${CTOR}" self)

        # No file provided
        Toolchain(SET "${self}" file_path "")

        # Initialize the toolchain object
        Toolchain(__initialize "${self}")

    endfunction()

    #[[[
    # Constructor for Toolchain object with a path to a toolchain file.
    #
    # :param toolchain_path: Path to the toolchain file to load.
    # :type toolchain_path: path
    #]]
    cpp_constructor(CTOR Toolchain path)
    function("${CTOR}" self toolchain_path)

        cpp_file_exists(toolchain_exists "${toolchain_path}")
        if(NOT "${toolchain_exists}")
            cpp_raise(FileNotFound "Provided toolchain file does not exist. Toolchain provided: ${toolchain_path}")
        endif()

        Toolchain(SET "${self}" file_path "${toolchain_path}")

        # Initialize the toolchain object
        Toolchain(__initialize "${self}")

        # Parse the user toolchain into a list of lines
        file(READ "${toolchain_path}" file_contents)
        # string(REPLACE "\"" "\\\"" file_contents "${file_contents}")
        
        # Parse user options
        Toolchain(_parse_toolchain "${self}" "${file_contents}")

    endfunction()

    #[[[
    # Constructor for Toolchain object with a string assumed to be the
    # contents of an already opened toolchain file.
    #
    # :param toolchain_contents: Contents of the toolchain file.
    # :type toolchain_contents: str
    #]]
    cpp_constructor(CTOR Toolchain str)
    function("${CTOR}" self toolchain_contents)

        # No file provided
        Toolchain(SET "${self}" file_path "")

        # Initialize the toolchain object
        Toolchain(__initialize "${self}")

        # Parse user options
        Toolchain(_parse_toolchain "${self}" "${toolchain_contents}")

    endfunction()

    #[[[
    # Creates a string of the toolchain values formatted to pass to the
    # CMAKE_ARGS keyword of something like ``ExternalProject_Add`` or
    # ``FetchContent``.
    #
    # .. note::
    #    Special characters are encoded using
    #    ``cmakepp_lang::utilities::cpp_encode_special_chars``
    #
    # :param toolchain_contents: Contents of the toolchain file.
    # :type toolchain_contents: str
    #]]
    cpp_member(as_cmake_args Toolchain str)
    function("${as_cmake_args}" self return_id)

        # Get the toolchain option map
        Toolchain(GET "${self}" toolchain_options toolchain_options)

        cpp_map(KEYS "${toolchain_options}" variables)

        # Collect the variables and values
        set(values "")
        foreach(var_name ${variables})
            cpp_map(GET "${toolchain_options}" value "${var_name}")
            string(APPEND values "-D${var_name}=\"${value}\" ")
            message("-- Values: ${values}")
        endforeach()

        # Replace the list semicolon with a text semicolon to
        # protect the list
        # string(REPLACE ";" "\;" values "${values}")
        message("-- Values: ${values}")
        cpp_encode_special_chars("${values}" encoded_values)

        message("-- Final Values: ${encoded_values}")

        set("${return_id}" "${encoded_values}" PARENT_SCOPE)

    endfunction()

    # [[[
    # Autopopulates certain toolchain variables as default values to be used
    # if not specified by the user toolchain file.
    # ]]
    cpp_member(_autopopulate_options Toolchain)
    function("${_autopopulate_options}" self)

        # Get the autopopulated map
        Toolchain(GET "${self}" auto_opt_map auto_options)

        # Autopopulate some values from the CMake environment
        cpp_map(SET "${auto_opt_map}" "CMAKE_C_COMPILER" "${CMAKE_C_COMPILER}")
        cpp_map(SET "${auto_opt_map}" "CMAKE_CXX_COMPILER" "${CMAKE_CXX_COMPILER}")
        # cpp_map(SET "${auto_opt_map}" "CMAKE_CXX_FLAGS" "${CMAKE_CXX_FLAGS}")
        # cpp_map(SET "${auto_opt_map}" "CMAKE_PREFIX_PATH" "${CMAKE_PREFIX_PATH}")

        # Copy autopopulated options to the user map
        cpp_map(COPY "${auto_opt_map}" user_opt_map)
        Toolchain(SET "${self}" toolchain_options "${user_opt_map}")

    endfunction()

    #[[[
    # Parses the given toolchain file contents and stores the options
    # in a map of user-set options.
    #]]
    cpp_member(_parse_toolchain Toolchain str)
    function("${_parse_toolchain}" self file_contents)

        # Get the toolchain option map (user options)
        Toolchain(GET "${self}" user_opt_map toolchain_options)

        string(REPLACE "\n" ";" lines "${file_contents}")

        set(in_block OFF)
        foreach(line ${lines})
            string(STRIP "${line}" line)

            # Check if it is the start of a block
            if(NOT in_block AND line MATCHES "^[ ]*([a-zA-Z0-9_]+)\\(")
                set(in_block ON)
            endif()

            # Append to the current command block
            if(in_block)
                string(APPEND current_block " ${line}")
            endif()

            # End of block, parse out the arguments
            if(in_block AND line MATCHES "\\)")
                # Notes on the regex used:
                # "[A-Za-z0-9_]" matches any single "word" character in the C locale
                #     - used for variable name extraction
                # ".+" matches any character one or more times
                #     - used to get values being stored in variables

                set(var_name "")
                set(var_value "")
                if(current_block MATCHES "set\\([ ]*([a-zA-Z0-9_]+)[ ]+(.+)[ ]*\\)")
                    set(var_name "${CMAKE_MATCH_1}")
                    set(var_value "${CMAKE_MATCH_2}")
                elseif(current_block MATCHES "list\\(APPEND[ ]+([a-zA-Z0-9_]+)[ ]+(.+)[ ]*\\)")
                    set(var_name "${CMAKE_MATCH_1}")

                    cpp_map(GET "${user_opt_map}" var_value "${CMAKE_MATCH_1}")
                    list(APPEND var_value "${CMAKE_MATCH_2}")
                elseif(current_block MATCHES "string\\(APPEND[ ]+([a-zA-Z0-9_]+)[ ]+\"(.+)\"[ ]*\\)")
                    set(var_name "${CMAKE_MATCH_1}")

                    cpp_map(GET "${user_opt_map}" var_value "${CMAKE_MATCH_1}")
                    string(APPEND var_value "${CMAKE_MATCH_2}")
                else()
                    cpp_raise(InvalidToolchainBlock "Unsupported command in toolchain: ${current_block}")
                endif()

                # Strip any excess spaces from the value
                string(STRIP "${var_value}" var_value)

                # Store/overwrite the value to the map
                cpp_map(SET "${user_opt_map}" "${var_name}" "${var_value}")

                set(in_block OFF)
                set(current_block "")
            endif()
        endforeach()

    endfunction()

    #[[[
    # Initialize empty option maps of the Toolchain object.
    #]]
    cpp_member(__initialize Toolchain)
    function("${__initialize}" self)

        # Set the user map to an empty map
        cpp_map(CTOR user_opt_map)
        Toolchain(SET "${self}" toolchain_options "${user_opt_map}")

        # Set the auto-populated map to an empty map
        cpp_map(CTOR auto_opt_map)
        Toolchain(SET "${self}" auto_options "${auto_opt_map}")

        # Autopopulate some options
        Toolchain(_autopopulate_options "${self}")

    endfunction()

cpp_end_class()
