# Try to find BCrypt library and include path.
# Once done this will define
#
# BCRYPT_FOUND
# BCRYPT_INCLUDE_DIR
# BCRYPT_LIBRARIES

find_path(BCRYPT_INCLUDE_DIR bcrypt.h)
if(MSVC)
  find_library(BCRYPT_LIBRARY bcrypt.lib)
else()
  find_library(BCRYPT_LIBRARY bcrypt)
endif()

# Handle the REQUIRED argument and set BCRYPT_FOUND
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(BCrypt DEFAULT_MSG BCRYPT_LIBRARY BCRYPT_INCLUDE_DIR)

mark_as_advanced(BCRYPT_INCLUDE_DIR)
mark_as_advanced(BCRYPT_LIBRARY)

if(BCRYPT_FOUND)
  add_definitions(-DBCRYPT_SUPPORT)
  set(BCRYPT_LIBRARIES ${BCRYPT_LIBRARY})
endif()
