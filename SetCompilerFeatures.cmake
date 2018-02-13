# Compiler features

# Enable C++14 or C++17 standard
if(CYGWIN)
  set(CMAKE_CXX_STANDARD 14)
else()
  set(CMAKE_CXX_STANDARD 17)
endif()
