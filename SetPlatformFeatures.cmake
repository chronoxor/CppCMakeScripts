# Platform features

if(WIN32)

  # Disable CRT secure warnings
  add_definitions(-D_CRT_SECURE_NO_DEPRECATE)

  # Windows 10
  add_definitions(-D_WIN32_WINNT=0x0A00)

endif()
