# MIT License
#
# Copyright (c) 2018 Daniel Mateja
#
# https://github.com/dmateja/CMakePrecompiledHeader
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

cmake_minimum_required( VERSION 3.12 )

function( target_precompiled_header pch_target pch_file )
	cmake_parse_arguments( pch "FORCE_INCLUDE" "REUSE" "EXCLUDE_LIST" ${ARGN} )

	if( pch_REUSE AND NOT TARGET "${pch_REUSE}" )
		message( SEND_ERROR "Re-use target \"${pch_REUSE}\" does not exist!" )
		return()
	endif()

	get_filename_component( pch_name ${pch_file} NAME )
	get_filename_component( pch_name_we ${pch_file} NAME_WE )
	get_filename_component( pch_dir ${pch_file} DIRECTORY )
	set( pch_h "${pch_file}" ) # StdAfx.h or Dir1/Dir2/StdAfx.h
	set( pch_pure_h "${pch_name}" ) # just StdAfx.h NOT Dir1/Dir2/StdAfx.h
	set( pch_pch "${pch_name}.pch" ) # just StdAfx.h.pch
	if( CMAKE_CXX_COMPILER_ID STREQUAL "GNU" )
		set( pch_pch "${pch_name}.gch" ) # just StdAfx.h.gch
	endif()
	set( pch_out_dir "${CMAKE_CURRENT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/${pch_target}.dir" )

	get_target_property( srcs ${pch_target} SOURCES )

	if( CMAKE_CXX_COMPILER_ID STREQUAL "MSVC" )
		# set path to c/cc/cpp/cxx next to h
		if( pch_dir )
			set( pch_cpp_reg ".*${pch_dir}/${pch_name_we}.\(cpp|cc|c\)$" )
		else()
			set( pch_cpp_reg ".*${pch_name_we}.\(cpp|cxx|cc|c\)$" )
		endif()

		if( pch_REUSE )
			get_target_property( pch_out ${pch_REUSE} PCH )
		else()
			set( pch_out "${pch_out_dir}/${pch_pch}" )
		endif()

		foreach( src ${srcs} )
			get_filename_component( src_name "${src}" NAME )
			
			if( ${src_name} IN_LIST pch_EXCLUDE_LIST )
				continue()
			endif()

			if( src MATCHES \\.\(cpp|cxx|cc|c\)$ )
				# precompiled cpp
				if( ${src} MATCHES ${pch_cpp_reg} )
					if( pch_cpp_found )
						message( FATAL_ERROR "Too many ${pch_file} in ${pch_target}")
					endif()
					set( pch_cpp_found TRUE )
					set_property( SOURCE ${src} APPEND PROPERTY OBJECT_OUTPUTS "${pch_out}" )
					set_property( SOURCE ${src} APPEND_STRING PROPERTY COMPILE_FLAGS " /Z7 /Yc${pch_pure_h} /Fp${pch_out}" )
				# common cpp
				else()
					if( NOT pch_REUSE )
						set( pch_cpp_needed TRUE )
					endif()
					set_property( SOURCE ${src} APPEND PROPERTY OBJECT_DEPENDS "${pch_out}" )
					set_property( SOURCE ${src} APPEND_STRING PROPERTY COMPILE_FLAGS " /Z7 /Yu${pch_pure_h} /Fp${pch_out}" )

					if( pch_FORCE_INCLUDE )
						set_property( SOURCE ${src} APPEND_STRING PROPERTY COMPILE_FLAGS " /FI${pch_pure_h}" )
					endif()
				endif()
			endif()
		endforeach()

		if( NOT pch_REUSE )
			set_property( TARGET ${pch_target} PROPERTY PCH "${pch_out}" )

			if( pch_cpp_needed AND NOT pch_cpp_found )
				message( FATAL_ERROR "Cpp ${pch_cpp} is required by MSVC" )
			endif()

			message( STATUS "Precompiled header '${pch_pure_h}' enabled for '${pch_target}' target" )
		endif()
	endif()

	if( CMAKE_CXX_COMPILER_ID MATCHES "~Clang|~GNU" AND UNIX )
		set( pch_out_h "${pch_out_dir}/${pch_name}" )
		set( pch_out "${pch_out_dir}/${pch_pch}" )
		set( pch_h_in "${CMAKE_CURRENT_SOURCE_DIR}/include/${pch_file}")

		### check deprecated COMPILE_FLAGS
		get_directory_property( for_check COMPILE_FLAGS )
		if( for_check )
			message( FATAL_ERROR "COMPILE_FLAGS is deprecated and not supported by precompiled headers: ${for_check}" )
		endif()
		get_target_property( for_check ${pch_target} COMPILE_FLAGS )
		if( for_check )
			message( FATAL_ERROR "COMPILE_FLAGS is deprecated and not supported by precompiled headers: ${for_check}" )
		endif()

		### prepare

		set( build_type ${CMAKE_BUILD_TYPE} )
		string( TOUPPER "${build_type}" build_type )
		set( current_build_cxx_flags ${CMAKE_CXX_FLAGS_${build_type}} )
		separate_arguments( current_build_cxx_flags )

		set( main_cmake_cxx_flags ${CMAKE_CXX_FLAGS} )
		separate_arguments( main_cmake_cxx_flags )

		# file with compilation options
		set( pch_opt "${pch_out_dir}/${pch_pch}.opt" )
		set( _tar_type "$<TARGET_PROPERTY:${pch_target},TYPE>" )
		set( _tar_pic "$<BOOL:$<TARGET_PROPERTY:${pch_target},POSITION_INDEPENDENT_CODE>>" )
		set( _tar_pic "$<IF:$<STREQUAL:${_tar_type},EXECUTABLE>,$<IF:${_tar_pic},-fPIE\n,-fno-PIE\n>,$<IF:${_tar_pic},-fPIC\n,-fno-PIC\n>>" )
		# TODO: problem with -isystem - now is -I
		set( _inc_def "$<TARGET_PROPERTY:${pch_target},INCLUDE_DIRECTORIES>" )
		set( _inc_def "$<$<BOOL:${_inc_def}>:-I$<JOIN:${_inc_def},\n-I>\n>" )
		set( _comp_def "$<TARGET_PROPERTY:${pch_target},COMPILE_DEFINITIONS>" )
		set( _comp_def "$<$<BOOL:${_comp_def}>:-D$<JOIN:${_comp_def},\n-D>\n>" )
		set( _comp_opt "$<TARGET_PROPERTY:${pch_target},COMPILE_OPTIONS>" )
		set( _comp_opt "$<$<BOOL:${_comp_opt}>:$<JOIN:${_comp_opt},\n>\n>" )
		set( main_cmake_cxx_flags "$<$<BOOL:${main_cmake_cxx_flags}>:$<JOIN:${main_cmake_cxx_flags},\n>\n>" )
		set( current_build_cxx_flags "$<$<BOOL:${current_build_cxx_flags}>:$<JOIN:${current_build_cxx_flags},\n>\n>" )
		# TODO: add CMAKE_CXX_STANDARD_REQUIRED
		set( _cxx_standard "$<TARGET_PROPERTY:${pch_target},CXX_STANDARD>" )
		set( _cxx_extensions "$<BOOL:$<TARGET_PROPERTY:${pch_target},CXX_EXTENSIONS>>" )
		set( _cxx_standard "$<IF:$<BOOL:${_cxx_standard}>,$<IF:${_cxx_extensions},-std=gnu++${_cxx_standard}\n,-std=c++${_cxx_standard}\n>,>" )

		file( GENERATE OUTPUT "${pch_opt}" CONTENT
			"${_cxx_standard}${main_cmake_cxx_flags}${_tar_pic}${current_build_cxx_flags}${_inc_def}${_comp_def}${_comp_opt}" )

		# add command to copy precompiled header and compile it
		add_custom_command(
			OUTPUT "${pch_out_h}" 
			COMMAND "${CMAKE_COMMAND}" -E copy "${pch_h_in}" "${pch_out_h}"
			COMMENT "Copying precompiled header"
		)
		# clang can read options from file by "@path_to_file"
		add_custom_command(
			OUTPUT "${pch_out}"
			COMMAND ${CMAKE_CXX_COMPILER} "@${pch_opt}" -x c++-header ${pch_h_in} -o ${pch_out}
			DEPENDS "${pch_out_h}" "${pch_opt}"
			COMMENT "Compiling precompiled header"
		)

		# set dependencies to precompiled header
		foreach( src ${srcs} )
			get_filename_component( src_name "${src}" NAME )
			
			if( ${src_name} IN_LIST pch_EXCLUDE_LIST )
				continue()
			endif()

			if( src MATCHES \\.\(cpp|cxx|cc|c\)$ )
				set_property( SOURCE ${src} APPEND PROPERTY OBJECT_DEPENDS "${pch_out}" )
				set_property( SOURCE ${src} APPEND_STRING PROPERTY COMPILE_FLAGS " -Winvalid-pch -include ${pch_out_h}" )
			endif()
		endforeach()
	endif()
endfunction()
