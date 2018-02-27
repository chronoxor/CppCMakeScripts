# Try to find Userenv library and include path.
# Once done this will define
#
# MSWSOCK_FOUND
# MSWSOCK_INCLUDE_DIR
# MSWSOCK_LIBRARIES

find_path(MSWSOCK_INCLUDE_DIR Mswsock.h)
if(NOT MSVC)
  find_library(MSWSOCK_LIBRARY Mswsock)
else()
  find_library(MSWSOCK_LIBRARY Mswsock.lib)
endif()

# Handle the REQUIRED argument and set MSWSOCK_FOUND
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(MSWSock DEFAULT_MSG MSWSOCK_LIBRARY MSWSOCK_INCLUDE_DIR)

mark_as_advanced(MSWSOCK_INCLUDE_DIR)
mark_as_advanced(MSWSOCK_LIBRARY)

if(MSWSOCK_FOUND)
  add_definitions(-DMSWSOCK_SUPPORT)
  set(WSOCK2_LIBRARIES ${MSWSOCK_LIBRARY})
endif()
