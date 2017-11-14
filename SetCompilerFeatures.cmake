# Compiler features

# Enable C++14 or C++17 standard
if(CYGWIN)
  set(CMAKE_CXX_STANDARD 14)
else()
  set(CMAKE_CXX_STANDARD 17)
endif()

# Clang libc++
if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -stdlib=libc++")
  if(NOT APPLE)
    set(CMAKE_CXX_STANDARD_LIBRARIES "${CMAKE_CXX_STANDARD_LIBRARIES} -lsupc++")
  endif()
endif()

# MSVC C++17 workaround
if(MSVC)
  if(MSVC_VERSION GREATER_EQUAL "1900")
    include(CheckCXXCompilerFlag)
    CHECK_CXX_COMPILER_FLAG("/std:c++latest" MSVC_LATEST)
    if(MSVC_LATEST)
      add_compile_options("/std:c++latest")
    endif()
  endif()
endif()
