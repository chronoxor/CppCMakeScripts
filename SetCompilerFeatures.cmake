# Compiler features

# Enable C++17 standard
set(CMAKE_CXX_STANDARD 17)

# Clang libc++
if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -stdlib=libc++")
  if(NOT APPLE)
    set(CMAKE_CXX_STANDARD_LIBRARIES "${CMAKE_CXX_STANDARD_LIBRARIES} -lc++abi -lsupc++")
  endif()
endif()
