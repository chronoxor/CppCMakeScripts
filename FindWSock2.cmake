# Try to find Userenv library and include path.
# Once done this will define
#
# WSOCK2_FOUND
# WSOCK2_INCLUDE_DIR
# WSOCK2_LIBRARIES

find_path(WSOCK2_INCLUDE_DIR WinSock2.h)
if(NOT MSVC)
  find_library(WSOCK2_LIBRARY ws2_32)
else()
  find_library(WSOCK2_LIBRARY ws2_32.lib)
endif()

# Handle the REQUIRED argument and set WSOCK2_FOUND
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(WSock2 DEFAULT_MSG WSOCK2_LIBRARY WSOCK2_INCLUDE_DIR)

mark_as_advanced(WSOCK2_INCLUDE_DIR)
mark_as_advanced(WSOCK2_LIBRARY)

if(WSOCK2_FOUND)
  add_definitions(-DWSOCK2_SUPPORT)
  set(WSOCK2_LIBRARIES ${WSOCK2_LIBRARY})
endif()
