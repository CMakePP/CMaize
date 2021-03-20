include_guard()
include(cpp/toolchain/map_wrapper.cmake)

cpp_class(toolchain map_wrapper)

	# Holds the path to the file to read from
	cpp_attr(toolchain file_path path)

	# List of keys from the toolchain file
	cpp_attr(toolchain toolchain_keys "")

	# Constructor to call the ctor of cpp_map
	cpp_constructor(CTOR toolchain path)
	function("${CTOR}" _this toolchain_path)

		# Check to see if there's a file
		cpp_file_exists(file_exists "${toolchain_path}")
		if("${file_exists}")
		else()
			message("ERROR: map_wrapper Contructor: Cannot find file at path: ${toolchain_path}")
			return()
		endif()

		# Instansiate a map by calling parent constructor
		map_wrapper(CTOR ${_this})

		# Update toolchain attribute
		toolchain(SET "${_this}" file_path ${toolchain_path})

		# Parse file to add keys & values to map
		file(READ "${toolchain_path}" file_contents)

		# Create a list of all variables and values in the toolchain file
		string(REGEX MATCHALL "(set\()[^\r\n]*\)" match_list "${file_contents}")

		toolchain(GET "${_this}" my_map mw_map)

		#message("String converted to list")
		foreach(match ${match_list})
			#message("${match}")
			string(FIND ${match} "\(" beg_index)
			string(FIND ${match} " " mid_index)
			string(FIND ${match} "\)" end_index REVERSE)
			#message("${beg_index} ${mid_index} ${end_index}")

			# Surounding the variable with "" causes a lot of warnings to pop up
			string(FIND ${match} "\"" quote_index) # returns -1 if cannot find
			string(COMPARE EQUAL "${quote_index}" "-1" res)

			MATH(EXPR beg_index "${beg_index} + 1")
			MATH(EXPR len_key "${mid_index} - ${beg_index}")

			if("${res}") # No quotes
				MATH(EXPR mid_index "${mid_index} + 1")
				MATH(EXPR len_val "${end_index} - ${mid_index}")
			else()
				MATH(EXPR mid_index "${mid_index} + 2")
				MATH(EXPR len_val "${end_index} - ${mid_index} - 1")
			endif()

			string(SUBSTRING ${match} ${beg_index} ${len_key} _key)
			string(SUBSTRING ${match} ${mid_index} ${len_val} _t_val)

			#remove { and replace with `[` to emulate {
			string(REPLACE "\{" "`[`" _val ${_t_val})

			toolchain(SET_VAL "${_this}" "${_key}" "${_val}")

			#######################################################
			# Grab key's value and store in map
			#######################################################
			#message("About to store ${_key} : ${${_key}}")
			#cpp_map(SET "${my_map}" "${_key}" "${${_key}}")

		endforeach()
		
		# Store variables added from toolchain file to warn against overwriting
		toolchain(KEYS "${_this}" key_list) # TODO : do this my_this inside the for loop
		toolchain(SET "${_this}" toolchain_keys "${key_list}")

		#TODO parse cache for more variables
	endfunction()

	# Overwrite the SET functionality with extra error checking
	cpp_member(SET_VAL toolchain str str)
	function("${SET_VAL}" _this _key_p _val_p)
		cpp_sanitize_string(_key_p "${_key_p}")
		# Grab list of variables set in toolchain file and see if we're setting one of them
		toolchain(GET "${_this}" _key_list toolchain_keys)
		foreach(_key ${_key_list})
			string(COMPARE EQUAL "${_key_p}" "${_key}" _comparison)
			#message("${_key_p} == ${_key}?: ${_comparison}")
			if(${_comparison})
				message("WARNING: You're overwritting \"${_key_p}\" which was set in the toolchain file")
				break()
			endif()
		endforeach()
		toolchain(GET "${_this}" my_map mw_map)
		cpp_map(SET "${my_map}" "${_key_p}" "${_val_p}")
	endfunction()
	
	# Remove value from string if key exists
	cpp_member(REMOVE toolchain str)
	function("${REMOVE}" _this _key_p)
		toolchain(HAS_KEY "${_this}" result ${_key_p})
		if("${result}")
			toolchain(SET_VAL "${_this}" "${_key_p}" removed)
		else()
			message("WARNING: Cannot remove \"${_key_p}.\" This key doesn't exist!")
		endif()
	endfunction()

	#hash _this based on keys and values ignoring ordering
	cpp_member(HASH toolchain desc)
	function("${HASH}" _this _return_id)
		toolchain(KEYS "${_this}" _key_list)
		list(SORT _key_list COMPARE STRING CASE INSENSITIVE)

		foreach(_key ${_key_list})
			# Add each value to a list
			toolchain(GET_VAL "${_this}" _val "${_key}")
			list(APPEND _val_list "${_val}")	
		endforeach()
				
		list(APPEND _key_list "${_val_list}")
		string(SHA256 _hash "${_key_list}")

        set("${_return_id}" "${_hash}" PARENT_SCOPE)
	endfunction()

cpp_end_class()
