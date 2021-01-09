# Compiler warnings

# Store origin compile flags
set(CMAKE_C_FLAGS_ORIGIN ${CMAKE_C_FLAGS})
set(CMAKE_CXX_FLAGS_ORIGIN ${CMAKE_CXX_FLAGS})

# Create custom compile flags
set(CMAKE_C_FLAGS_CUSTOM ${CMAKE_C_FLAGS})
set(CMAKE_CXX_FLAGS_CUSTOM ${CMAKE_CXX_FLAGS})

if(MSVC)

  # Set warnings level 4
  set(CMAKE_C_WARNING_LEVEL 4)
  set(CMAKE_CXX_WARNING_LEVEL 4)
  if(CMAKE_C_FLAGS_CUSTOM MATCHES "/W[0-4]")
    string(REGEX REPLACE "/W[0-4]" "/W4" CMAKE_C_FLAGS_CUSTOM ${CMAKE_C_FLAGS_CUSTOM})
  else()
    set(CMAKE_C_FLAGS_CUSTOM "${CMAKE_C_FLAGS_CUSTOM} /W4")
  endif()
  if(CMAKE_CXX_FLAGS_CUSTOM MATCHES "/W[0-4]")
    string(REGEX REPLACE "/W[0-4]" "/W4" CMAKE_CXX_FLAGS_CUSTOM ${CMAKE_CXX_FLAGS_CUSTOM})
  else()
    set(CMAKE_CXX_FLAGS_CUSTOM "${CMAKE_CXX_FLAGS_CUSTOM} /W4")
  endif()

  # Make all warnings into errors and increases the number of sections that an object file can contain
  set(CMAKE_C_FLAGS_CUSTOM "${CMAKE_C_FLAGS_CUSTOM} /WX /bigobj")
  set(CMAKE_CXX_FLAGS_CUSTOM "${CMAKE_CXX_FLAGS_CUSTOM} /WX /bigobj")

  # Common compile flags
  # C4100: 'identifier' : unreferenced formal parameter
  # C4250: 'class1' : inherits 'class2::member' via dominance
  set(COMMON_COMPILE_FLAGS "/wd4100 /wd4250")

  # Pedantic compile flags
  set(PEDANTIC_COMPILE_FLAGS ${COMMON_COMPILE_FLAGS})

else()

  # Make all warnings into errors
  set(CMAKE_C_FLAGS_CUSTOM "${CMAKE_C_FLAGS_CUSTOM} -Wall -Werror")
  set(CMAKE_CXX_FLAGS_CUSTOM "${CMAKE_CXX_FLAGS_CUSTOM} -Wall -Werror")

  # MinGW-w64 increases the number of sections that an object file can contain
  if(MINGW OR MSYS)
    set(CMAKE_C_FLAGS_CUSTOM "${CMAKE_C_FLAGS_CUSTOM} -Wa,-mbig-obj")
    set(CMAKE_CXX_FLAGS_CUSTOM "${CMAKE_CXX_FLAGS_CUSTOM} -Wa,-mbig-obj")
  endif()

  # Common compile flags
  set(COMMON_COMPILE_FLAGS "")

  # Pedantic compile flags
  set(PEDANTIC_COMPILE_FLAGS "${COMMON_COMPILE_FLAGS} -Wshadow -pedantic")

endif()

# Update compile flags
set(CMAKE_C_FLAGS ${CMAKE_C_FLAGS_CUSTOM})
set(CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS_CUSTOM})
