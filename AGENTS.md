# AGENTS.md

This file provides guidance to AI Agents when working with code in this repository.

## Repository purpose

CppCMakeScripts is a library of reusable CMake modules consumed as a subdirectory (typically a git submodule at `cmake/`) by C++ projects. It has no build of its own — there is no `CMakeLists.txt`, no tests, and no lint target. Changes are validated by consuming projects that `include()` these `.cmake` files.

## Module layout

Two kinds of modules live in the repo root:

- **Configuration modules** — included by a consumer's `CMakeLists.txt` for side effects (setting flags, defining options, registering targets):
  - `SetCompilerFeatures.cmake` — sets `CMAKE_CXX_STANDARD 23`, libc++ on Clang, MSYS/MinGW static linking, MSVC `/bigobj` `/utf-8` `/Zc:__cplusplus`, Unix pthreads.
  - `SetCompilerWarnings.cmake` — turns `-Wall -Werror` (or `/W4 /WX` on MSVC) on, then exposes `PEDANTIC_COMPILE_FLAGS` and `COMMON_COMPILE_FLAGS` for per-target use.
  - `SetPlatformFeatures.cmake` — adds Windows platform `add_definitions` (`WIN32_LEAN_AND_MEAN`, `_WIN32_WINNT=0x0A00`, SDK version, etc.).
  - `CodeCoverage.cmake` — gated on `-DCODE_COVERAGE=ON`; adds `--coverage -O0`, writes `CTestCustom.cmake` to scope coverage to `include/` and `source/`, and defines a `coverage-gcovr` custom target when `gcovr` is on PATH. MSVC is rejected with `FATAL_ERROR`.
  - `SystemInformation.cmake` — prints identification info; no side effects beyond `message()`.

- **`Find<Pkg>.cmake` modules** — `find_path` + `find_library` for libraries CMake doesn't ship finders for: `Crypt` (Windows crypt32), `DbgHelp`, `LibBFD`, `LibDL`, `LibRT`, `LibUUID`, `RPC`, `Userenv`, `WinSock`. Each sets `<PKG>_FOUND`, `<PKG>_INCLUDE_DIR`, `<PKG>_LIBRARIES` and uses `FindPackageHandleStandardArgs`. Some (e.g. `FindCrypt.cmake`) also `add_definitions(-D<PKG>_SUPPORT)` when found and append to `CMAKE_*_STANDARD_LIBRARIES` under MinGW.

## Conventions to preserve

- Keep modules side-effect-explicit and standalone — a consumer does `include(cmake/SetCompilerWarnings.cmake)` and expects exactly the documented globals/targets, nothing else.
- Cross-compiler branching follows `MSVC` / `MINGW`/`MSYS` / `APPLE` / `UNIX` / `CMAKE_CXX_COMPILER_ID STREQUAL "Clang"|"GNU"`. Match this style when adding flags.
- `SetCompilerWarnings.cmake` deliberately preserves originals into `CMAKE_*_FLAGS_ORIGIN` before mutating `CMAKE_*_FLAGS`. Don't remove that backup.
- `CodeCoverage.cmake` uses `gcov -l -p` on purpose: without `-p`, same-basename headers from different directories (e.g. project `thread.h` vs libc++ `__thread/thread.h`) collide and CTest mis-maps system-header line counts to project files. The inline comment explains this — leave it in place if you touch the file.
- The `CTestCustom.cmake` exclusion list in `CodeCoverage.cmake` assumes a consumer layout with `include/` and `source/` as the only "real" code dirs; everything else (`tests/`, `examples/`, `performance/`, `plugins/`, `modules/`, `bin/`, `build/`, `temp/`, `documents/`, `images/`, `cmake/`) is excluded. Add new exclusions here rather than in consumer projects.

## Validating changes

There is nothing to build or test in this repo directly. To verify a change, run a consuming project's CMake configure + build + (if relevant) `ctest -T Coverage` / `cmake --build . --target coverage-gcovr`.
