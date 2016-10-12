# Compiler warnings

if(NOT MSVC)

  # Make all warnings into errors
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -Werror")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Werror")

  # Common compile flags
  set(COMMON_COMPILE_FLAGS "-Wno-unused-variable")

  # Pedantic compile flags
  set(PEDANTIC_COMPILE_FLAGS "${COMMON_COMPILE_FLAGS} -Wextra -Wshadow -pedantic")

  # Benchmark compile flags
  set(BENCHMARK_COMPILE_FLAGS "${PEDANTIC_COMPILE_FLAGS}")

else()

  # Set warnings level 4
  set(CMAKE_C_WARNING_LEVEL 4)
  if(CMAKE_C_FLAGS MATCHES "/W[0-4]")
    string(REGEX REPLACE "/W[0-4]" "/W4" CMAKE_C_FLAGS "${CMAKE_C_FLAGS}")
  else()
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /W4")
  endif()
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /WX")
  set(CMAKE_CXX_WARNING_LEVEL 4)
  if(CMAKE_CXX_FLAGS MATCHES "/W[0-4]")
    string(REGEX REPLACE "/W[0-4]" "/W4" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
  else()
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /W4")
  endif()

  # Make all warnings into errors
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /WX")

  # Common compile flags
  # C4100: 'identifier' : unreferenced formal parameter
  set(COMMON_COMPILE_FLAGS "/wd4100")

  # Pedantic compile flags
  set(PEDANTIC_COMPILE_FLAGS "${COMMON_COMPILE_FLAGS}")

  # Benchmark compile flags
  # C4250: 'class1' : inherits 'class2::member' via dominance
  set(BENCHMARK_COMPILE_FLAGS "${PEDANTIC_COMPILE_FLAGS} /wd4250")

endif()
