# Platform features

if(CYGWIN)

  # Base Windows platform
  add_definitions(-DWIN32)

  # Windows 10
  add_definitions(-D_WIN32_WINNT=0x0A00)

elseif(WIN32)

  # Base Windows platform
  add_definitions(-DWIN32)

  # Disable CRT secure warnings
  add_definitions(-D_CRT_SECURE_NO_DEPRECATE)

  # Disable C++17 deprecation warnings
  add_definitions(-D_SILENCE_ALL_CXX17_DEPRECATION_WARNINGS)

  # Windows 10
  add_definitions(-D_WIN32_WINNT=0x0A00)

  # Windows SDK
  if(CMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION AND NOT MINGW)
    string(REGEX REPLACE "^([0-9]+)\\.([0-9]+)\\.([0-9]+)\\.([0-9]+)$" "\\3" CMAKE_WIN32_SDK ${CMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION})
  else()
    string(REGEX REPLACE "^([0-9]+)\\.([0-9]+)\\.([0-9]+)$" "\\3" CMAKE_WIN32_SDK ${CMAKE_SYSTEM_VERSION})
  endif()
  add_definitions(-D_WIN32_SDK=${CMAKE_WIN32_SDK})

endif()

# GCC compiler fix for precompiled headers
if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
  add_definitions(-D__cpp_runtime_arrays=198712)
endif()
