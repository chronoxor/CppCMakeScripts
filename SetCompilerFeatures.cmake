# Compiler features

# Choose C++ standard
if(CMAKE_VERSION VERSION_LESS "3.10")
  if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=gnu++17")
  endif()
else()
  set(CMAKE_CXX_STANDARD 17)
endif()
