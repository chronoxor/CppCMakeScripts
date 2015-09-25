#.rst:
# FindWinSock
# --------
#
# Find the native realtime includes and library.
#
# IMPORTED Targets
# ^^^^^^^^^^^^^^^^
#
# This module defines :prop_tgt:`IMPORTED` target ``WINSOCK::WINSOCK``, if
# WINSOCK has been found.
#
# Result Variables
# ^^^^^^^^^^^^^^^^
#
# This module defines the following variables:
#
# ::
#
#   WINSOCK_INCLUDE_DIRS  - where to find winsock.h, etc.
#   WINSOCK_LIBRARIES     - List of libraries when using librt.
#   WINSOCK_FOUND         - True if realtime library found.
#
# Hints
# ^^^^^
#
# A user may set ``WINSOCK_ROOT`` to a realtime installation root to tell this
# module where to look.

macro(REMOVE_DUPLICATE_PATHS LIST_VAR)
  set(WINSOCK_LIST "")
  foreach(PATH IN LISTS ${LIST_VAR})
    get_filename_component(PATH "${PATH}" REALPATH)
    list(APPEND WINSOCK_LIST "${PATH}")
  endforeach(PATH)
  set(${LIST_VAR} ${WINSOCK_LIST})
  list(REMOVE_DUPLICATES ${LIST_VAR})
endmacro(REMOVE_DUPLICATE_PATHS)

set(WINSOCK_INCLUDE_PATHS "${WINSOCK_ROOT}/include/")
if(MINGW)
  execute_process(
    COMMAND ${CMAKE_C_COMPILER} -xc -E -v -
    RESULT_VARIABLE RESULT
    INPUT_FILE nul
    ERROR_VARIABLE ERR
    OUTPUT_QUIET
  )
  if (NOT RESULT)
    string(FIND "${ERR}" "#include <...> search starts here:" START)
    string(FIND "${ERR}" "End of search list." END)
    if (NOT ${START} EQUAL -1 AND NOT ${END} EQUAL -1)
      math(EXPR START "${START} + 36")
      math(EXPR END "${END} - 1")
      math(EXPR LENGTH "${END} - ${START}")
      string(SUBSTRING "${ERR}" ${START} ${LENGTH} WINSOCK_INCLUDE_PATHS)
      string(REPLACE "\n " ";" WINSOCK_INCLUDE_PATHS "${WINSOCK_INCLUDE_PATHS}")
      list(REVERSE WINSOCK_INCLUDE_PATHS)
    endif()
  endif()
endif()
remove_duplicate_paths(WINSOCK_INCLUDE_PATHS)

set(WINSOCK_LIBRARY_PATHS "${WINSOCK_ROOT}/lib/")
if(MINGW)
  execute_process(
    COMMAND ${CMAKE_C_COMPILER} -print-search-dirs
    RESULT_VARIABLE RESULT
    OUTPUT_VARIABLE OUT
    ERROR_QUIET
  )
  if (NOT RESULT)
    string(REGEX MATCH "libraries: =([^\r\n]*)" OUT "${OUT}")
    list(APPEND WINSOCK_LIBRARY_PATHS "${CMAKE_MATCH_1}")
  endif()
endif()
if (${CMAKE_HOST_SYSTEM_PROCESSOR} STREQUAL "AMD64" AND ${CMAKE_SIZEOF_VOID_P} EQUAL 4)
  list(APPEND WINSOCK_LIBRARY_PATHS "C:/Windows/SysWOW64")
endif()
list(APPEND WINSOCK_LIBRARY_PATHS "C:/Windows/System32")
remove_duplicate_paths(WINSOCK_LIBRARY_PATHS)

find_path(WINSOCK_INCLUDE_DIRS
  NAMES winsock2.h
  PATHS ${WINSOCK_INCLUDE_PATHS}
)
find_library(WINSOCK_LIBRARIES_WS2_32 ws2_32
  PATHS ${WINSOCK_LIBRARY_PATHS}
  NO_DEFAULT_PATH
)
find_library(WINSOCK_LIBRARIES_WSOCK32 wsock32
  PATHS ${WINSOCK_LIBRARY_PATHS}
  NO_DEFAULT_PATH
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(WinSock DEFAULT_MSG WINSOCK_LIBRARIES_WS2_32 WINSOCK_LIBRARIES_WSOCK32 WINSOCK_INCLUDE_DIRS)
mark_as_advanced(WINSOCK_INCLUDE_DIRS WINSOCK_LIBRARIES_WS2_32 WINSOCK_LIBRARIES_WSOCK32)

if(WINSOCK_FOUND)
  if(NOT TARGET WINSOCK::WS2_32)
    add_library(WINSOCK::WS2_32 UNKNOWN IMPORTED)
    set_target_properties(WINSOCK::WS2_32 PROPERTIES
      IMPORTED_LOCATION "${WINSOCK_LIBRARIES_WS2_32}"
      INTERFACE_INCLUDE_DIRECTORIES "${WINSOCK_INCLUDE_DIRS}")
    add_library(WINSOCK::WSOCK32 UNKNOWN IMPORTED)
    set_target_properties(WINSOCK::WSOCK32 PROPERTIES
      IMPORTED_LOCATION "${WINSOCK_LIBRARIES_WSOCK32}"
      INTERFACE_INCLUDE_DIRECTORIES "${WINSOCK_INCLUDE_DIRS}")
  endif()
endif()
