# Try to find Userenv library and include path.
# Once done this will define
#
# WINSOCK_FOUND
# WINSOCK_INCLUDE_DIR
# WINSOCK_LIBRARIES

find_path(WINSOCK_INCLUDE_DIR WinSock2.h)
if(NOT MSVC)
  find_library(WINSOCK_LIBRARY wsock32)
  find_library(WINSOCK2_LIBRARY ws2_32)
else()
  find_library(WINSOCK_LIBRARY wsock32.lib)
  find_library(WINSOCK2_LIBRARY ws2_32.lib)
endif()

# Handle the REQUIRED argument and set WINSOCK_FOUND
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(WinSock DEFAULT_MSG WINSOCK_LIBRARY WINSOCK2_LIBRARY WINSOCK_INCLUDE_DIR)

mark_as_advanced(WINSOCK_INCLUDE_DIR)
mark_as_advanced(WINSOCK_LIBRARY)
mark_as_advanced(WINSOCK2_LIBRARY)

if(WINSOCK_FOUND)
  add_definitions(-DWINSOCK_SUPPORT)
  set(WINSOCK_LIBRARIES ${WINSOCK_LIBRARY} ${WINSOCK2_LIBRARY})
endif()
