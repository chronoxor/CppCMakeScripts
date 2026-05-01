# Code coverage support

if(CODE_COVERAGE)
  if(MSVC)
    message(FATAL_ERROR "Code coverage is not supported with MSVC compiler! Use GCC or Clang instead.")
  endif()

  # Use --coverage flag for both GCC and Clang (equivalent to -fprofile-arcs -ftest-coverage)
  add_compile_options(--coverage -O0)
  add_link_options(--coverage -O0)

  message(STATUS "Code coverage is enabled")
endif()
