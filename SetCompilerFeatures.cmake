# Compiler features

# Choose C++ standard
if(CYGWIN)
  set(CMAKE_CXX_STANDARD 14)
else()
  set(CMAKE_CXX_STANDARD 17)
endif()
