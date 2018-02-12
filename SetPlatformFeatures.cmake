# Platform features

if(WIN32)

  # Base Windows platform
  add_definitions(-DWIN32)

  # Windows 10
  add_definitions(-D_WIN32_WINNT=0x0A00)

endif()
