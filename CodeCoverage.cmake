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

  # Restrict CTest coverage accumulation to include/ and source/ only.
  # Patterns are regexes matched against the full file path; anything that
  # does NOT live under those two directories is excluded.
  file(WRITE "${CMAKE_BINARY_DIR}/CTestCustom.cmake"
    "set(CTEST_CUSTOM_COVERAGE_EXCLUDE\n"
    "  \".*/bin/.*\"\n"
    "  \".*/build/.*\"\n"
    "  \".*/cmake/.*\"\n"
    "  \".*/documents/.*\"\n"
    "  \".*/examples/.*\"\n"
    "  \".*/images/.*\"\n"
    "  \".*/performance/.*\"\n"
    "  \".*/plugins/.*\"\n"
    "  \".*/modules/.*\"\n"
    "  \".*/temp/.*\"\n"
    "  \".*/tests/.*\"\n"
    ")\n"
  )

  # gcovr flags: skip branches that can never be reached, lines that are
  # non-executable (comments, blank lines), and implicit throw branches
  # injected by the compiler for exception-safe code.
  find_program(GCOVR_PATH gcovr)
  if(GCOVR_PATH AND NOT TARGET coverage-gcovr)
    add_custom_target(coverage-gcovr
      COMMAND ${GCOVR_PATH}
        --exclude-unreachable-branches
        --exclude-noncode-lines
        --exclude-throw-branches
        --root ${CMAKE_SOURCE_DIR}
        --object-directory ${CMAKE_BINARY_DIR}
      WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
      COMMENT "Running gcovr coverage report"
    )
    message(STATUS "gcovr found: ${GCOVR_PATH}")
  else()
    message(STATUS "gcovr not found, coverage-gcovr target not available")
  endif()

  message(STATUS "Code coverage is enabled")
endif()
