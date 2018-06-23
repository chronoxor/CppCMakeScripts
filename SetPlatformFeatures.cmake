# Platform features

if(CYGWIN)

  # Cygwin string.empty() workaround
  add_definitions(-D_GLIBCXX_USE_CXX17_ABI)

endif()

if(WIN32)

  # Base Windows platform
  add_definitions(-DWIN32)

  # Disable CRT secure warnings
  add_definitions(-D_CRT_SECURE_NO_DEPRECATE)

  # Disable C++17 deprecation warnings
  add_definitions(-D_SILENCE_ALL_CXX17_DEPRECATION_WARNINGS)

  # Windows 10
  add_definitions(-D_WIN32_WINNT=0x0A00)

  # Windows SDK
  string(REGEX REPLACE "10.0.(.*)" "\\1" CMAKE_WIN32_SDK ${CMAKE_SYSTEM_VERSION})
  add_definitions(-D_WIN32_SDK=${CMAKE_WIN32_SDK})

endif()
