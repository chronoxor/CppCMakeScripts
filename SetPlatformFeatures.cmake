# Platform features

if(WIN32)

  # Base Windows platform
  add_definitions(-DWIN32)

  # Disable CRT secure warnings
  add_definitions(-D_CRT_SECURE_NO_DEPRECATE)

  # Windows 10
  add_definitions(-D_WIN32_WINNT=0x0A00)

endif()
