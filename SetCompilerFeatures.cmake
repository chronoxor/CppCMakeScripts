# Compiler features

# Enable C++17 standard
set(CMAKE_CXX_STANDARD 17)

# Cygwin C++17 workaround
if(CYGWIN)
  set(CMAKE_CXX_STANDARD 14)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++17")
endif()

# Clang libc++
if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -stdlib=libc++")
  if(NOT APPLE)
    set(CMAKE_CXX_STANDARD_LIBRARIES "${CMAKE_CXX_STANDARD_LIBRARIES} -lc++abi -lsupc++")
  endif()
endif()
