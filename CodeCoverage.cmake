# Code coverage support

if(CODE_COVERAGE)
  if(MSVC)
    message(FATAL_ERROR "Code coverage is not supported with MSVC compiler! Use GCC or Clang instead.")
  endif()

  # Use --coverage flag for both GCC and Clang (equivalent to -fprofile-arcs -ftest-coverage)
  add_compile_options(--coverage -O0)
  add_link_options(--coverage -O0)

  # Use -l -p so gcov encodes the full source path into each .gcov filename.
  # Without -p, files with the same basename from different directories (e.g.
  # include/threads/thread.h and the libc++ __thread/thread.h) produce the same
  # output filename, causing the second run to overwrite the first.  CTest then
  # reads system-header line counts but maps them to the project header, causing
  # "Problem reading source file" errors during coverage accumulation.
  set(COVERAGE_EXTRA_FLAGS "-l -p" CACHE STRING "Extra flags for gcov coverage" FORCE)

  message(STATUS "Code coverage is enabled")
endif()
